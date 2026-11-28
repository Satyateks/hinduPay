import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindu_pay/core/widgets/app_bottom_navigation.dart';
import 'package:hindu_pay/features/astrologer/data/datasources/astrologer_remote_datasource.dart';
import 'package:hindu_pay/features/astrologer/data/repositories/astrologer_repository_impl.dart';
import 'package:hindu_pay/features/astrologer/domain/usecases/get_astrologer_by_id.dart';
import 'package:hindu_pay/features/astrologer/domain/usecases/get_astrologers.dart';
import 'package:hindu_pay/features/astrologer/presentation/bloc/astrologer_bloc.dart';
import 'package:hindu_pay/features/astrologer/presentation/bloc/astrologer_event.dart';
import 'package:hindu_pay/features/astrologer/presentation/bloc/astrologer_state.dart';
import 'package:hindu_pay/features/astrologer/presentation/pages/astrologer_list_page.dart';
import 'package:hindu_pay/features/astrologer/presentation/pages/astrologer_profile_page.dart';
import 'package:hindu_pay/main_shall.dart';

AstrologerBloc _createTestBloc() {
  final dataSource = AstrologerRemoteDataSourceImpl();
  final repository = AstrologerRepositoryImpl(remoteDataSource: dataSource);
  return AstrologerBloc(
    getAstrologers: GetAstrologers(repository: repository),
    getAstrologerById: GetAstrologerById(repository: repository),
    repository: repository,
  );
}

void main() {
  group('Astrologer module', () {
    test('MainShell shows bottom bar on astrologer list and profile routes', () {
      expect(MainShell.shouldShowBottomBar('/main/astrologers'), isTrue);
      expect(
        MainShell.shouldShowBottomBar('/main/astrologers/profile/sivaguru'),
        isTrue,
      );
    });

    test('AstrologerBloc loads, filters by category and search, and toggles favorite', () async {
      final bloc = _createTestBloc();
      bloc.add(const LoadAstrologers());

      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<AstrologerState>()
              .having((s) => s.status, 'status', AstrologerStatus.loaded)
              .having((s) => s.filteredAstrologers.length, 'count', 6),
        ),
      );

      bloc.add(const SelectAstrologerCategory('Vedic'));
      await expectLater(
        bloc.stream,
        emits(isA<AstrologerState>()
              .having((s) => s.selectedCategory, 'selectedCategory', 'Vedic')
              .having((s) => s.filteredAstrologers.map((a) => a.name).toList(),'names',['Chajapathi']),
        ),
      );

      bloc.add(const SelectAstrologerCategory('All'));
      bloc.add(const SearchAstrologers('Bengali'));
      await expectLater(bloc.stream,
        emitsThrough(isA<AstrologerState>().having((s) => s.filteredAstrologers.map((a) => a.name).toList(),'bengali astrologers',['Maishaa', 'Prakhar'])),
      );

      bloc.add(const ToggleFavoriteAstrologer('sivaguru'));
      await expectLater(
        bloc.stream,
        emitsThrough(
          isA<AstrologerState>().having((s) => s.astrologers.firstWhere((a) => a.id == 'sivaguru').isFavorite,'sivaguru favorite',isTrue),
        ),
      );

      await bloc.close();
    });

    testWidgets('AstrologerListPage renders consultation list and filters cleanly', (tester) async {
      final bloc = _createTestBloc()..add(const LoadAstrologers());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AstrologerBloc>.value(
            value: bloc,
            child: const Scaffold(
              body: AstrologerListPage(),
              bottomNavigationBar: _DummyNav(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Astrologer Consultation'), findsOneWidget);
      expect(find.text('Sivaguru'), findsOneWidget);
      expect(find.text('Maishaa'), findsOneWidget);
      expect(find.text('Numerology'), findsWidgets);
      expect(find.text('Call Now'), findsWidgets);
      expect(find.text('Chat Now'), findsWidgets);

      await tester.tap(find.text('Nadi').first);
      await tester.pumpAndSettle();

      expect(find.text('Prakhar'), findsOneWidget);
      expect(find.text('Maishaa'), findsNothing);

      await bloc.close();
    });

    testWidgets('AstrologerProfilePage renders profile banner, bio, and consultation sheet', (tester) async {
      final bloc = _createTestBloc()..add(const LoadAstrologers());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AstrologerBloc>.value(value: bloc,
            child: const AstrologerProfilePage(astrologerId: 'sivaguru')
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Sivaguru'), findsOneWidget);
      expect(find.textContaining('Booked 1035+ times this month'), findsOneWidget);
      expect(find.textContaining('celebrity Tarot Card Reader'), findsOneWidget);

      await tester.tap(find.text('Chat Now'));
      await tester.pumpAndSettle();

      expect(find.text('Chat with Sivaguru'), findsOneWidget);
      expect(find.text('Start Chat Now'), findsOneWidget);

      await bloc.close();
    });
  });
}

class _DummyNav extends StatelessWidget {
  const _DummyNav();

  @override
  Widget build(BuildContext context) {
    return AppBottomNavigation(currentIndex: 1, onTap: (_) {});
  }
}
