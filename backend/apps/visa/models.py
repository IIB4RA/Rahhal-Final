import uuid
from django.db import models
from apps.accounts.models import User 

class Passports(models.Model):
    id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False)
    
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        db_column='user_id',
        related_name='passport'
    )
    
    passport_number = models.CharField(max_length=50, unique=True)
    full_name = models.TextField()
    nationality = models.CharField(max_length=10) 
    
    birth_date = models.DateField(null=True, blank=True)
    expiry_date = models.DateField()
    
    scan_url = models.URLField(max_length=500, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'visa"."passports'




class Applications(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('expired', 'Expired'),

    ]
    VISA_TYPE_ChOICES = [
        ('tourist', 'Tourist'),
        ('business', 'Business'),
        ('transit', 'Transit'),
        ('religious', 'Religious')
    ]
        
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4, 
        editable=False)
    
    user = models.ForeignKey(
        User, 
        on_delete=models.CASCADE,  
        db_column='user_id'
    )
    passport = models.ForeignKey(
        Passports, 
        on_delete=models.CASCADE, 
        db_column='passport_id'
    )
    # payment = models.ForeignKey(
    #     'Transaction', 
    #     on_delete=models.SET_NULL, 
    #     null=True, 
    #     blank=True, 
    #     db_column='payment_id'
    # )

    visa_type = models.CharField(
        max_length=50,
        choices=VISA_TYPE_ChOICES
        )

    status = models.CharField(
        max_length=20, 
        choices=STATUS_CHOICES,
        default='pending'
    )

    applied_date = models.DateField(auto_now_add=True)
    processed_date = models.DateField(null=True, blank=True)
    processing_days = models.IntegerField(null=True, blank=True)
    
    rejection_reason = models.TextField(null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False 
        db_table = 'visa"."applications'




class Tourist_Pass(models.Model):
    STATUS_CHOICES = [
        ('expired', 'Expired'),
        ('active', 'Active'),
        ('suspended', 'Suspended'),
    ]
    
    id = models.UUIDField(
        primary_key=True, 
        default=uuid.uuid4, 
        editable=False)
    
    user = models.ForeignKey(
        User, 
        on_delete=models.CASCADE, 
        db_column='user_id'
    )
    visa = models.ForeignKey(
        Applications, 
        on_delete=models.CASCADE, 
        db_column='visa_id'
    )

    pass_code = models.TextField(unique=True)
    qr_data = models.TextField()

    status = models.CharField(
        max_length=50, 
        choices=STATUS_CHOICES, 
        default='active'
        )

    issued_date = models.DateField(auto_now_add=True)
    expiry_date = models.DateField()
    
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'visa"."tourist_pass'
