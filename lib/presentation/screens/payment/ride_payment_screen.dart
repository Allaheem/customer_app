import 'package:equatable/equatable.dart'; // Import Equatable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Import actual BookingBloc/PaymentBloc, Events, States
// TODO: Import actual RatingScreen
// TODO: Import PaymentOptionsScreen if needed to change method

// Placeholder BLoC components - Replace with actual imports
abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class ApplyPromoCode extends BookingEvent {
  final String code;
  const ApplyPromoCode(this.code);
  @override
  List<Object?> get props => [code];
}

class ProcessPayment extends BookingEvent {
  const ProcessPayment();
}

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingRideCompleted extends BookingState {
  final String rideId;
  final dynamic finalFare; // e.g., {'amount': 30.0, 'currency': 'SAR', 'discountApplied': false, 'promoCode': null}
  const BookingRideCompleted({required this.rideId, this.finalFare});
  @override
  List<Object?> get props => [rideId, finalFare];

  BookingRideCompleted copyWith({dynamic finalFare}) {
    return BookingRideCompleted(rideId: rideId, finalFare: finalFare ?? this.finalFare);
  }
}

class BookingApplyingPromoCode extends BookingState {
  final BookingRideCompleted rideDetails;
  const BookingApplyingPromoCode(this.rideDetails);
  @override
  List<Object?> get props => [rideDetails];
}

class BookingProcessingPayment extends BookingState {
  final BookingRideCompleted rideDetails;
  const BookingProcessingPayment(this.rideDetails);
  @override
  List<Object?> get props => [rideDetails];
}

class BookingPaymentSuccessful extends BookingState {
  final String rideId;
  final dynamic finalFare;
  const BookingPaymentSuccessful(this.rideId, this.finalFare);
  @override
  List<Object?> get props => [rideId, finalFare];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object?> get props => [message];
}

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  // Using BookingRideCompleted as initial state for testing this screen
  BookingBloc() : super(const BookingRideCompleted(rideId: 'test_ride_123', finalFare: {'amount': 55.0, 'currency': 'SAR'})) {
    on<ApplyPromoCode>((event, emit) async {
      if (state is BookingRideCompleted) {
        final currentState = state as BookingRideCompleted;
        // print("Bloc received apply promo code: ${event.code}");
        emit(BookingApplyingPromoCode(currentState));
        await Future.delayed(const Duration(milliseconds: 500));
        // Simulate applying discount
        dynamic updatedFare = Map.from(currentState.finalFare ?? {});
        double originalAmount = updatedFare['amount'] ?? 0.0;
        double discount = (event.code.toLowerCase() == 'save10') ? (originalAmount * 0.1) : 0.0;
        updatedFare['amount'] = (originalAmount - discount).clamp(0.0, double.infinity);
        updatedFare['discountApplied'] = discount > 0;
        updatedFare['promoCode'] = event.code;

        emit(currentState.copyWith(finalFare: updatedFare));
      }
    });
    on<ProcessPayment>((event, emit) async {
      if (state is BookingRideCompleted) {
        final currentState = state as BookingRideCompleted;
        // print("Bloc received process payment for ride ${currentState.rideId}");
        emit(BookingProcessingPayment(currentState));
        await Future.delayed(const Duration(seconds: 2));
        // Simulate payment success
        emit(BookingPaymentSuccessful(currentState.rideId, currentState.finalFare));
      }
    });
  }
}
// End Placeholder BLoC components

// Placeholder Screen for Navigation
class PlaceholderRatingScreen extends StatelessWidget {
  final String rideId;
  const PlaceholderRatingScreen({super.key, required this.rideId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Ride - Placeholder"), automaticallyImplyLeading: false),
      body: Center(child: Text("Payment Successful! Please rate ride ID: $rideId")),
    );
  }
}
// End Placeholder Screen

class RidePaymentScreen extends StatefulWidget {
  // This screen expects the state to be BookingRideCompleted or related payment processing states
  const RidePaymentScreen({super.key});

  @override
  State<RidePaymentScreen> createState() => _RidePaymentScreenState();
}

class _RidePaymentScreenState extends State<RidePaymentScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    if (_promoController.text.isNotEmpty) {
      // TODO: Use actual BookingBloc
      context.read<BookingBloc>().add(ApplyPromoCode(_promoController.text));
      FocusScope.of(context).unfocus(); // Hide keyboard
    }
  }

  void _confirmPayment() {
    // TODO: Use actual BookingBloc
    context.read<BookingBloc>().add(const ProcessPayment());
  }

  void _changePaymentMethod() {
    // TODO: Navigate to PaymentOptionsScreen
    // print("Navigate to change payment method");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Change Payment Method Tapped / تم النقر على تغيير طريقة الدفع")), // Placeholder
    );
  }

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context); // Assuming theme is provided

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment / الدفع"),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
        automaticallyImplyLeading: false, // Prevent going back during payment
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<BookingBloc, BookingState>(
        // TODO: Use actual BookingBloc
        listener: (context, state) {
          if (state is BookingPaymentSuccessful) {
            // Navigate to Rating Screen
            Navigator.pushReplacement(
              context,
              // TODO: Use actual RatingScreen
              MaterialPageRoute(builder: (context) => PlaceholderRatingScreen(rideId: state.rideId)),
            );
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.redAccent));
          }
        },
        builder: (context, state) {
          if (state is BookingRideCompleted || state is BookingApplyingPromoCode || state is BookingProcessingPayment) {
            final detailsState = (state is BookingRideCompleted)
                ? state
                : (state is BookingApplyingPromoCode)
                    ? state.rideDetails
                    : (state as BookingProcessingPayment).rideDetails;

            final bool isApplyingPromo = state is BookingApplyingPromoCode;
            final bool isProcessingPayment = state is BookingProcessingPayment;
            final bool isLoading = isApplyingPromo || isProcessingPayment;

            final fareDetails = detailsState.finalFare ?? {};
            final double amount = fareDetails['amount'] ?? 0.0;
            final String currency = fareDetails['currency'] ?? 'SAR';
            final bool discountApplied = fareDetails['discountApplied'] ?? false;
            final String appliedPromo = fareDetails['promoCode'] ?? '';

            // TODO: Get default payment method details from UserBloc/PaymentBloc
            const String defaultPaymentMethod = "Visa ending in 4242"; // Placeholder

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Ride Completed! / اكتملت الرحلة!",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Final Fare / الأجرة النهائية",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${amount.toStringAsFixed(2)} $currency",
                    style: TextStyle(color: Colors.amber[700], fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (discountApplied)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Discount Applied / تم تطبيق الخصم ($appliedPromo)",
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 40),

                  // Promo Code Input (Knowledge ID: user_50)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          enabled: !isLoading && !discountApplied, // Disable if loading or discount already applied
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: discountApplied ? 'Promo Applied / تم تطبيق الكود' : 'Promo Code / كود الخصم',
                            labelStyle: TextStyle(color: Colors.amber[700]),
                            hintText: 'Enter code / أدخل الكود',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: isLoading || discountApplied ? null : _applyPromoCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                        child: isApplyingPromo
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("Apply / تطبيق"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Payment Method Display
                  Text(
                    "Paying with / الدفع بواسطة:",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.credit_card, color: Colors.amber[700]), // TODO: Dynamic icon
                    title: const Text(defaultPaymentMethod, style: TextStyle(color: Colors.white, fontSize: 16)),
                    trailing: TextButton(
                      onPressed: isLoading ? null : _changePaymentMethod,
                      child: Text("Change / تغيير", style: TextStyle(color: Colors.amber[700])),
                    ),
                  ),
                  const Spacer(),

                  // Confirm Payment Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: isProcessingPayment
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                        : const Text("Confirm Payment / تأكيد الدفع"),
                  ),
                ],
              ),
            );
          } else {
            // Handle unexpected states (e.g., BookingInitial)
            // For testing, let's show the payment screen with default data
            // In real app, might show error or redirect
            // print("Unexpected state in RidePaymentScreen: $state");
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }
        },
      ),
    );
  }
}

