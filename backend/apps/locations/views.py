from rest_framework import permissions, viewsets
from .models import Transport_Option
from .serializers import TransportOptionSerializer

class TransportOptionViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Transport_Option.objects.all()
    serializer_class = TransportOptionSerializer
    permission_classes = [permissions.IsAuthenticated]
