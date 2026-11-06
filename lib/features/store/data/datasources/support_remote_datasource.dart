import '../../domain/entities/support_ticket.dart';
import '../models/support_ticket.dart';

abstract class SupportRemoteDataSource {
  Future<List<SupportFaq>> getFaqs();

  Future<SupportTicketModel> createTicket({
    required String subject,
    required String description,
    required String category,
    required String email,
  });
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final List<SupportTicketModel> _tickets = [];

  @override
  Future<List<SupportFaq>> getFaqs() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const [
      SupportFaq(
        id: 'faq_1',
        category: 'Orders',
        question: 'How can I track my order?',
        answer: 'Open Store > My Orders and select your order to view its current status.',
      ),
      SupportFaq(
        id: 'faq_2',
        category: 'Payments',
        question: 'My payment is pending. What should I do?',
        answer:'Check your order status before retrying payment. If the amount was debited, submit a support request with your order details.',
      ),
      SupportFaq(
        id: 'faq_3',
        category: 'Delivery',
        question: 'Can I change my delivery address?',
        answer: 'Address changes may depend on the order status. Contact support as soon as possible.',
      ),
      SupportFaq(
        id: 'faq_4',
        category: 'Returns',
        question: 'What if my product arrives damaged?',
        answer: 'Submit a support request and include your order number and a description of the damage.',
      ),
      SupportFaq(
        id: 'faq_5',
        category: 'Orders',
        question: 'Where can I find my order ID?',
        answer:'Your order ID is shown on the order confirmation screen and in My Orders.',
      ),
      SupportFaq(
        id: 'faq_6',
        category: 'Orders',
        question: 'Where can I find my order ID?',
        answer:'Your order ID is shown on the order confirmation screen and in My Orders.',
      ),
  
    ];
  }

  @override
  Future<SupportTicketModel> createTicket({
    required String subject,
    required String description,
    required String category,
    required String email,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final ticket = SupportTicketModel(
      id: 'HP-SUP-${DateTime.now().millisecondsSinceEpoch}',
      subject: subject,
      description: description,
      category: category,
      email: email,
      status: SupportTicketStatus.submitted,
      createdAt: DateTime.now(),
    );

    _tickets.add(ticket);
    return ticket;
  }
}
