from django.db import models
import uuid
from apps.accounts.models import User
from apps.attractions.models  import Hotel, Tour
from apps.locations.models import Transport_Option
from apps.payment.models import Transaction


class Booking(models.Model):
    BOOKING_TYPE_CHOICES = [
        ('hotel', 'Hotel'),
        ('tour', 'Tour'),
        ('transport', 'Transport'),
    ]

    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('confirmed', 'Confirmed'),
        ('cancelled', 'Cancelled'),
        ('completed', 'Completed'),
    ]

    id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False
    )
    
    user_id = models.ForeignKey(
        User, 
        on_delete=models.CASCADE,
        related_name='bookings',
        db_column='user_id'
    )
    
    payment_id = models.OneToOneField(
        Transaction, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        db_column='payment_id'
    )

    booking_type = models.CharField(
        max_length=20, 
        choices=BOOKING_TYPE_CHOICES
    )
    status = models.CharField(
        max_length=20, 
        choices=STATUS_CHOICES, 
        default='pending'
    )
    
    total_price = models.DecimalField(max_digits=12, decimal_places=2)
    currency = models.CharField(max_length=3, default='JOD')

    start_date = models.DateField()
    end_date = models.DateField(null=True, blank=True)
    
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'booking"."bookings'
        managed = False




class Hotel_Booking(models.Model):
    id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False
    )
    
    booking_id = models.OneToOneField(
        Booking, 
        on_delete=models.CASCADE, 
        related_name='hotel_booking',
        db_column='booking_id'
    )
    
    hotel_id = models.ForeignKey(
        Hotel, 
        on_delete=models.PROTECT,
        related_name='bookings',
        db_column='hotel_id'
    )
    
    rooms = models.PositiveIntegerField(default=1)
    nights = models.PositiveIntegerField()
    guests = models.PositiveIntegerField(default=1)
    
    check_in = models.DateField()
    check_out = models.DateField()

    class Meta:
        db_table = 'booking"."hotel_bookings'
        managed = False




class Tour_Booking(models.Model):
    id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False
    )
    
    booking_id = models.OneToOneField(
        Booking, 
        on_delete=models.CASCADE, 
        related_name='tour_booking',
        db_column='booking_id'
    )
    
    tour_id = models.ForeignKey(
        Tour, 
        on_delete=models.PROTECT,
        related_name='bookings',
        db_column='tour_id'
    )
    
    guests = models.PositiveIntegerField(default=1)
    tour_date = models.DateField()

    class Meta:
        db_table = 'booking"."tour_bookings'
        managed = False




class Transport_Booking(models.Model):
    id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False
    )
    
    booking_id = models.OneToOneField(
        Booking, 
        on_delete=models.CASCADE, 
        related_name='transport_booking',
        db_column='booking_id'
    )
    
    option_id = models.ForeignKey(
        Transport_Option, 
        on_delete=models.PROTECT,
        related_name='bookings',
        db_column='option_id'
    )
    
    passengers = models.PositiveIntegerField(default=1)
    travel_date = models.DateField()
    pickup_location = models.TextField(null=True, blank=True)

    class Meta:
        db_table = 'booking"."transport_bookings'
        managed = False

