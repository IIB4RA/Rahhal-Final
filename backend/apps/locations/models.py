from django.db import models

class Region(models.Model):
    name_en = models.TextField(null=False)
    name_ar = models.TextField(null=False)
    
    slug = models.TextField(unique=True, null=False)
    
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=False)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=False)
    
    description_en = models.TextField(null=True, blank=True)
    description_ar = models.TextField(null=True, blank=True)
    
    image_url = models.TextField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'tourism"."regions'
        managed = False





class Transport_Option(models.Model):
    from_city = models.TextField(null=False)
    to_city = models.TextField(null=False)
    
    type = models.TextField(null=False)
    
    price = models.DecimalField(max_digits=10, decimal_places=2, null=False)
    
    duration_mins = models.IntegerField(null=True, blank=True)
    
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = 'tourism"."transport_options'
        managed = False