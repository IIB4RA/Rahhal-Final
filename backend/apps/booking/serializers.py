from rest_framework import serializers

from .models import Booking, Hotel_Booking, Tour_Booking, Transport_Booking
from apps.attractions.serializers import HotelSerializer

# class BookingSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Booking
#         fields = (
#             "id",
#             "booking_type",
#             "status",
#             "total_price",
#             "currency",
#             "start_date",
#             "end_date",
#             "notes",
#             "payment",
#         )
#         read_only_fields = ("id", "status", "total_price")




class HotelBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hotel_Booking
        fields = (
            "hotel_id",
            "rooms",
            "nights",
            "check_in",
            "check_out",
            "guests",
        )




class TourBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tour_Booking
        fields = (
            "tour_id",
            "guests",
            "tour_date",
        )

 


class TransportBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transport_Booking
        fields = (
            "option_id",
            "passengers",
            "travel_date",
            "pickup_location",
        )
