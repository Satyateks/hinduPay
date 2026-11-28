import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../domain/entities/astrologer.dart';
import '../bloc/astrologer_bloc.dart';
import '../bloc/astrologer_event.dart';
import '../bloc/astrologer_state.dart';
import '../widgets/astrologer_card.dart';
import '../widgets/astrologer_category_chips.dart';
import '../widgets/astrologer_search_header.dart';
import '../widgets/consultation_action_sheet.dart';

class AstrologerListPage extends StatefulWidget {
  const AstrologerListPage({super.key});

  @override
  State<AstrologerListPage> createState() => _AstrologerListPageState();
}

class _AstrologerListPageState extends State<AstrologerListPage> {
  final TextEditingController _searchController = TextEditingController();
  late final stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      await _speech.initialize(
        onStatus: (_) {
          if (mounted) setState(() => _isListening = _speech.isListening);
        },
        onError: (error) {debugPrint('Astrologer speech error: $error');},
      );
    } catch (_) {
      // Speech recognition may be unavailable in tests or unsupported platforms.
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    try {
      if (_speech.isListening) {
        await _speech.stop();
        return;
      }

      final available = await _speech.initialize();
      if (!available) return;

      await _speech.listen(
        localeId: 'en_IN',
        onResult: (result) {
          if (!mounted) return;
          final words = result.recognizedWords;
          setState(() {
            _searchController.value = TextEditingValue(
              text: words,
              selection: TextSelection.collapsed(offset: words.length),
            );
          });
          context.read<AstrologerBloc>().add(SearchAstrologers(words));
        },
      );
    } catch (_) {
      // Ignore speech failures gracefully.
    }
  }

  void _openProfile(Astrologer astrologer) {
    final bloc = context.read<AstrologerBloc>();
    context.pushNamed('astrologer-profile',
      pathParameters: {'id': astrologer.id},
      extra: {'astrologer': astrologer, 'bloc': bloc},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.14, 0.30, 1.0],
            colors: [
              Color(0xFFF36B21),
              Color(0xFFF79458),
              Color(0xFFFFF5EA),
              Color(0xFFFFFDF9),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, _, _) {
                  return AstrologerSearchHeader(
                    controller: _searchController,
                    isListening: _isListening,
                    onChanged: (query) {
                      context.read<AstrologerBloc>().add(
                        SearchAstrologers(query));
                    },
                    onMicTap: _toggleListening,
                    onClearTap: () {
                      _searchController.clear();
                      context.read<AstrologerBloc>().add(
                        const SearchAstrologers(''),
                      );
                    },
                    onProfileTap: () => context.push('/main/profile'),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Astrologer Consultation',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1E1E),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push('/main/astrologers/horoscope'),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFD8B4FE),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 14,
                              color: Color(0xFF9333EA),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Horoscope',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7E22CE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<AstrologerBloc, AstrologerState>(
                buildWhen: (prev, curr) =>
                    prev.categories != curr.categories ||
                    prev.selectedCategory != curr.selectedCategory,
                builder: (context, state) {
                  return AstrologerCategoryChips(
                    categories: state.categories,
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (category) {
                      context.read<AstrologerBloc>().add(
                        SelectAstrologerCategory(category),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<AstrologerBloc, AstrologerState>(
                  builder: (context, state) {
                    if (state.status == AstrologerStatus.loading ||
                        state.status == AstrologerStatus.initial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF36B21),
                        ),
                      );
                    }

                    if (state.status == AstrologerStatus.failure &&
                        state.astrologers.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 42,
                                color: Color(0xFFF36B21),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.errorMessage ??
                                    'Unable to load astrologers',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<AstrologerBloc>()
                                    .add(const LoadAstrologers()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF36B21),
                                  minimumSize: const Size(120, 40),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final items = state.filteredAstrologers;
                    if (items.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome_outlined,
                                size: 44,
                                color: Color(0xFFF36B21),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'No astrologers match your filter',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2B2B2B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<AstrologerBloc>().add(const SelectAstrologerCategory('All'));
                                  context.read<AstrologerBloc>().add(const SearchAstrologers(''));
                                },
                                child: const Text(
                                  'Reset filters',
                                  style: TextStyle(color: Color(0xFFF36B21)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: const Color(0xFFF36B21),
                      onRefresh: () async {
                        context.read<AstrologerBloc>().add(
                          const LoadAstrologers(),
                        );
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 2, 16, 110),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final astrologer = items[index];
                          return AstrologerCard(
                            astrologer: astrologer,
                            onTap: () => _openProfile(astrologer),
                            onFavoriteTap: () {
                              context.read<AstrologerBloc>().add(
                                ToggleFavoriteAstrologer(astrologer.id),
                              );
                            },
                            onCallTap: () => showConsultationActionSheet(
                              context,
                              astrologer: astrologer,
                              isCall: true,
                            ),
                            onChatTap: () => showConsultationActionSheet(
                              context,
                              astrologer: astrologer,
                              isCall: false,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
