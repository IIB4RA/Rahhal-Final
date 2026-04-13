from rest_framework import permissions, viewsets
from .models import Booking, Hotel_Booking, Tour_Booking, Transport_Booking
from .serializers import HotelBookingSerializer, TourBookingSerializer, TransportBookingSerializer
from apps.attractions.models import Hotel, Tour
from apps.locations.models import Transport_Option

class HotelBookingView(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = HotelBookingSerializer

    def get_queryset(self):
        return Hotel_Booking.objects.filter(booking_id__user_id=self.request.user).select_related("booking_id", "hotel_id")

    def perform_create(self, serializer):
        hotel_id = self.request.data.get('hotel_id')
        rooms = int(self.request.data.get('rooms', 1))
        nights = int(self.request.data.get('nights', 1))

        hotel = Hotel.objects.get(id=hotel_id)

        total_price = hotel.price_per_night * rooms * nights

        new_booking = Booking.objects.create(
            user_id=self.request.user,
            booking_type='hotel',
            status='pending',
            total_price=total_price,
            start_date=self.request.data.get('check_in'),
            end_date=self.request.data.get('check_out'),
            notes=self.request.data.get('notes'),
        )

        serializer.save(booking_id=new_booking)




class TourBookingView(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = TourBookingSerializer

    def get_queryset(self):
        return Tour_Booking.objects.filter(booking_id__user_id=self.request.user).select_related("booking_id", "tour_id")

    def perform_create(self, serializer):
        tour_id = self.request.data.get('tour_id')
        tour = Tour.objects.get(id=tour_id)
        tour_price = tour.price

        new_booking = Booking.objects.create(
            user_id=self.request.user,
            booking_type='tour',
            status='pending',
            total_price=tour_price,
            start_date=self.request.data.get('tour_date'),
            notes=self.request.data.get('notes'),
        )

        serializer.save(booking_id=new_booking)





class TransportBookingView(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = TransportBookingSerializer

    def get_queryset(self):
        return Transport_Booking.objects.filter(booking_id__user_id=self.request.user).select_related("booking_id", "option_id")

    def perform_create(self, serializer):
        option_id = self.request.data.get('option_id')
        option = Transport_Option.objects.get(id=option_id)
        option_price = option.price

        new_booking = Booking.objects.create(
            user_id=self.request.user,
            booking_type='transport',
            status='pending',
            total_price=option_price,
            start_date=self.request.data.get('travel_date'), 
            notes=self.request.data.get('notes'),
        )

        serializer.save(booking_id=new_booking)
