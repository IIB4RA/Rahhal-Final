from rest_framework import serializers
from .models import Transport_Option

class TransportOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transport_Option
        fields = (
            'id',
            'from_city',
            'to_city',
            'type',
            'price',
            'duration_mins',
            'is_active',
        )
        read_only_fields = fields