from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import JordanLocation
#from .serializers import LocationSerializer

@api_view(['GET', 'POST'])
def locations(request):

    if request.method == 'GET':
        data = Location.objects.all()
        return Response(LocationSerializer(data, many=True).data)

    if request.method == 'POST':
        serializer = LocationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)