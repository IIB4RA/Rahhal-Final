from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from apps.booking.models import Booking
from .models import Transaction
from .services import process_mock_payment

class BookingPaymentView(APIView):
    def post(self, request):
        booking_id = request.data.get('booking_id')
        
        try:
            booking = Booking.objects.get(id=booking_id, user=request.user)
            
            if booking.status == 'completed':
                return Response({"error": "Already paid"}, status=status.HTTP_400_BAD_REQUEST)

            payment_result = process_mock_payment(booking.total_price)

            if payment_result['success']:
                txn = Transaction.objects.create(
                    user_id=request.user,
                    amount=booking.total_price,
                    status='paid',
                    provider=payment_result['provider'],
                    provider_ref=payment_result['reference'],
                    reference_type='booking',
                    reference_id=booking.id
                    )

                booking.status = 'completed'
                booking.payment_id = txn 
                booking.save()

                return Response({"message": "Payment Successful", "transaction_id": txn.id}, status=status.HTTP_200_OK)
            
            return Response({"error": "Payment Declined"}, status=status.HTTP_402_PAYMENT_REQUIRED)

        except Booking.DoesNotExist:
            return Response({"error": "Booking not found"}, status=status.HTTP_404_NOT_FOUND)