import os

from django.conf import settings
from django.http import JsonResponse
from django.shortcuts import render


def home(request):
    return render(request, 'home.html')


VERSION_FILE = os.path.join(settings.BASE_DIR, '__version__.txt')


def status(request):
    try:
        with open(VERSION_FILE) as version_file:
            version = version_file.read().strip()
    except Exception:
        version = 'unknown'

    return JsonResponse({
        'version': version,
        'ident': os.environ.get('IDENT', 'unknown'),
    })
