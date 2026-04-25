from django.db import models
from apps.accounts.models import User
from apps.locations.models import Region

class VisitorLog(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    region = models.ForeignKey(Region, on_delete=models.SET_NULL, null=True, blank=True)
    
    duration_mins = models.IntegerField(default=0)
    
    device_type = models.CharField(max_length=50, null=True, blank=True) # Android, iOS, Web
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:

        db_table = 'analytics"."visitor_logs'
        managed = False 

    def __str__(self):
        return f"Visit to {self.region} at {self.created_at}"