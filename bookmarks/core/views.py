from django.http import JsonResponse
from django.shortcuts import render


def home(request):
    return render(request, 'home.html')


def status(request):
    return JsonResponse({'status': 'ok', 'version': 'unknown'})
