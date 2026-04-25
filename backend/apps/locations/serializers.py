from rest_framework import serializers
from .models import Transport_Option, JordanLocation 

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
        read_only_fields = ('id', 'duration_mins') 

class JordanLocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = JordanLocation
        fields = '__all__'
        read_only_fields = ('duration_mins',)