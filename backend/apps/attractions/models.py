from django.db import models
from apps.locations.models import Region

class Operator(models.Model):
    name = models.TextField(null=False)
    
    license_number = models.TextField(unique=True, null=False)
    
    phone = models.TextField(null=True, blank=True)
    email = models.TextField(null=True, blank=True)
    
    is_verified = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'tourism"."operators'
        managed = False





class Hotel(models.Model):
    region_id = models.ForeignKey(
        Region, 
        on_delete=models.CASCADE, 
        related_name='hotels',
        db_column='region_id'
    )
    
    name_en = models.TextField()
    name_ar = models.TextField()
    
    stars = models.PositiveSmallIntegerField() 
    total_rooms = models.IntegerField()
    price_per_night = models.DecimalField(max_digits=10, decimal_places=2)
    
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    
    image_url = models.URLField(max_length=500, null=True, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'tourism"."hotels'
        managed = False





class Attraction(models.Model):
    ATTRACTION_CHOICES = [
        ('historical', 'Historical'),
        ('nature', 'Historical'),
        ('religious', 'Historical'),
        ('adventure', 'Historical'),
        ('cultural', 'Historical'),
        ('beach', 'Historical'),
        ('desert', 'Historical'),
    ]
    region_id = models.ForeignKey(
        Region, 
        on_delete=models.CASCADE, 
        related_name='attractions',
        db_column='region_id'
    )
    
    name_en = models.TextField()
    name_ar = models.TextField()
    description_en = models.TextField(null=True, blank=True)
    description_ar = models.TextField(null=True, blank=True)
    
    category = models.CharField(
        max_length=50, 
        choices=ATTRACTION_CHOICES
    )
    
    latitude = models.DecimalField(max_digits=9, decimal_places=6)
    longitude = models.DecimalField(max_digits=9, decimal_places=6)
    
    entry_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    image_url = models.URLField(max_length=500, null=True, blank=True)
    
    avg_rating = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    total_reviews = models.PositiveIntegerField(default=0)
    
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'tourism"."attractions'
        managed = False




class Tour(models.Model):
    region_id = models.ForeignKey(
        Region, 
        on_delete=models.CASCADE, 
        related_name='tours',
        db_column='region_id'
    )
    
    operator_id = models.ForeignKey(
        Operator, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='offered_tours',
        db_column='operator_id'
    )
    
    name_en = models.TextField()
    name_ar = models.TextField()
    description_en = models.TextField(null=True, blank=True)
    description_ar = models.TextField(null=True, blank=True)
    
    price = models.DecimalField(max_digits=10, decimal_places=2)
    max_guests = models.PositiveIntegerField(null=True, blank=True)
    duration_hours = models.DecimalField(max_digits=4, decimal_places=1, null=True, blank=True)
    
    image_url = models.URLField(max_length=500, null=True, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'tourism"."tours'
        managed = False





class Event(models.Model):
    region_id = models.ForeignKey(
        Region, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='events',
        db_column='region_id'
    )
    
    name_en = models.TextField()
    name_ar = models.TextField()
    description_en = models.TextField(null=True, blank=True)
    description_ar = models.TextField(null=True, blank=True)
    
    location = models.TextField(null=True, blank=True) 
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    
    event_date = models.DateField()
    price = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    image_url = models.URLField(max_length=500, null=True, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'tourism"."events'
        managed = False
        ordering = ['event_date']




class Attraction_Content(models.Model):
    attraction_id = models.OneToOneField(
        Attraction,
        on_delete=models.CASCADE, 
        related_name='contents',
        db_column='attraction_id'
    )
    
    content_type = models.TextField(db_column='type')
    
    language = models.CharField(max_length=10,)
    
    content_url = models.URLField()
    
    created_at = models.DateTimeField(
        auto_now_add=True, 
        null=True, 
    )

    class Meta:
        db_table = 'tourism"."attraction_content'
        managed = False  
