# /backend/main.py

from fastapi import FastAPI
from pydantic import BaseModel

# Definisikan struktur data untuk input dari frontend
class RouteRequest(BaseModel):
    start_location: str
    end_location: str
    preference: int | None = None # 0: Sejuk, 1: Bersih, 2: Tenang


# Buat instance aplikasi
app = FastAPI()


@app.get("/")
def read_root():
    return {"message": "Server RuteSejuk berhasil berjalan!"}


# Ubah endpoint menjadi POST untuk menerima data
@app.post("/api/v1/route")
def create_route(request: RouteRequest):
    """
    Menerima data lokasi awal dan tujuan, lalu mengembalikan rute palsu.
    """
    # Print data yang diterima dari Flutter untuk debugging
    print(f"Menerima request rute dari: {request.start_location} ke: {request.end_location}")
    print(f"Preferensi yang dipilih: {request.preference}")

    # Untuk sekarang, kita tetap kembalikan data rute palsu
    return {
        "message": "Data diterima, ini adalah rute palsu dari server",
        "route_points": [
            {"lat": -6.17, "lon": 106.82},
            {"lat": -6.17, "lon": 106.84},
            {"lat": -6.19, "lon": 106.84},
            {"lat": -6.19, "lon": 106.82},
            {"lat": -6.17, "lon": 106.82},
        ]
    }