from django.db import models
import uuid
from apps.accounts.models import User

class Transaction(models.Model):
    STATUS_CHOICES = [
        ('paid', 'Paid'),
        ('pending', 'Pending'),
        ('failed', 'Failed'),
        ('refunded', 'Refunded'),
    ]
    PROVIDER_CHOICES = [
        ('stripe', 'Stripe'),
        ('paypal', 'Paypal'),
        ('cash', 'Cash'),
        ('other', 'Other'),
    ]


    id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False
    )
    
    user_id = models.ForeignKey(
        User, 
        on_delete=models.CASCADE, 
        related_name='transactions',
        db_column='user_id'
    )
    
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    currency = models.CharField(max_length=3, default='JOD')
    
    status = models.CharField(
        max_length=20, 
        choices=STATUS_CHOICES,
        default='pending'
        )
    
    provider = models.CharField(
        max_length=50,
        choices=PROVIDER_CHOICES,
        ) 

    provider_ref = models.TextField(null=True, blank=True)
    
    reference_type = models.TextField(null=True, blank=True) 
    reference_id = models.UUIDField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'payment"."transactions'
        managed = False
