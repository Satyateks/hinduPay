import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactItem {
  final String name;
  final String phoneOrUpi;
  final String initials;
  final Color avatarBg;

  const ContactItem({
    required this.name,
    required this.phoneOrUpi,
    required this.initials,
    required this.avatarBg,
  });
}

class MobilePayPage extends StatefulWidget {
  const MobilePayPage({super.key});

  @override
  State<MobilePayPage> createState() => _MobilePayPageState();
}

class _MobilePayPageState extends State<MobilePayPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<ContactItem> _recents = const [
    ContactItem(
      name: 'Sakshi Jain',
      phoneOrUpi: '+91 70824 60754',
      initials: 'SJ',
      avatarBg: Color(0xFFFF8A80),
    ),
    ContactItem(
      name: 'Anil Singh',
      phoneOrUpi: 'anilsingh.12@okhdfcbank',
      initials: 'AS',
      avatarBg: Color(0xFF81C784),
    ),
  ];

  final List<ContactItem> _allContacts = const [
    ContactItem(
      name: 'Subhash Kumar',
      phoneOrUpi: '9824428528',
      initials: 'SK',
      avatarBg: Color(0xFF64B5F6),
    ),
    ContactItem(
      name: 'Aman Kumar',
      phoneOrUpi: '9824428528',
      initials: 'AK',
      avatarBg: Color(0xFFBA68C8),
    ),
    ContactItem(
      name: 'Subhash Kumar',
      phoneOrUpi: '9824428528',
      initials: 'SK',
      avatarBg: Color(0xFF4DD0E1),
    ),
    ContactItem(
      name: 'Aman Kumar',
      phoneOrUpi: '9824428528',
      initials: 'AK',
      avatarBg: Color(0xFFFFB74D),
    ),
    ContactItem(
      name: 'Subhash Kumar',
      phoneOrUpi: '9824428528',
      initials: 'SK',
      avatarBg: Color(0xFFF06292),
    ),
    ContactItem(
      name: 'Aman Kumar',
      phoneOrUpi: '9824428528',
      initials: 'AK',
      avatarBg: Color(0xFF81C784),
    ),
    ContactItem(
      name: 'Subhash Kumar',
      phoneOrUpi: '9824428528',
      initials: 'SK',
      avatarBg: Color(0xFF4DB6AC),
    ),
    ContactItem(
      name: 'Aman Kumar',
      phoneOrUpi: '9824428528',
      initials: 'AK',
      avatarBg: Color(0xFF7986CB),
    ),
  ];

  List<ContactItem> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = _allContacts;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        _filteredContacts = _allContacts.where((c) =>c.name.toLowerCase().contains(query) || c.phoneOrUpi.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onContactTap(ContactItem contact) {
    context.push(
      '/upi/pay',
      extra: {
        'name': contact.name,
        'phone': contact.phoneOrUpi,
        'amount': 14000.0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // TOP BAR: < Search [Mic]
            // ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF212121), size: 19),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
                              decoration: const InputDecoration(
                                hintText: 'Search by name or number',
                                hintStyle: TextStyle(fontSize: 13, color: Color(0xFFBDBDBD)),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (query) {
                                if (query.trim().isNotEmpty) {
                                  context.push(
                                    '/upi/pay',
                                    extra: {
                                      'name': query.trim(),
                                      'phone': query.trim(),
                                      'amount': 14000.0,
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          const Icon(Icons.mic_none_outlined, color: Color(0xFF757575), size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // ------------------------------------------------
                  // RECENTS SECTION
                  // ------------------------------------------------
                  if (_searchController.text.isEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8, left: 4),
                      child: Text(
                        'Recents',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: List.generate(_recents.length, (idx) {
                          final contact = _recents[idx];
                          final isLast = idx == _recents.length - 1;
                          return Column(
                            children: [
                              _buildContactTile(contact),
                              if (!isLast)
                                Divider(height: 1, thickness: 1, indent: 68, color: Colors.grey[100]),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ------------------------------------------------
                  // CONTACTS SECTION
                  // ------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8, left: 4),
                    child: Text(
                      'Contacts (${_filteredContacts.length})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(_filteredContacts.length, (idx) {
                        final contact = _filteredContacts[idx];
                        final isLast = idx == _filteredContacts.length - 1;
                        return Column(
                          children: [
                            _buildContactTile(contact),
                            if (!isLast)
                              Divider(height: 1, thickness: 1, indent: 68, color: Colors.grey[100]),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(ContactItem contact) {
    return InkWell(
      onTap: () => _onContactTap(contact),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: contact.avatarBg,
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    contact.phoneOrUpi,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
