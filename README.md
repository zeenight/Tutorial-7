#  Tutorial 7 – FPS Controller & Scene System (Godot)

##  Deskripsi

Project ini merupakan implementasi dasar sistem **First Person 3d** menggunakan **Godot Engine**.
Fitur yang dibuat mencakup pergerakan player, kontrol kamera, serta sistem perpindahan scene.

---

## Fitur yang Diimplementasikan

###  Player Movement

* Movement menggunakan **WASD**
* Menggunakan sistem `CharacterBody3D`
* Pergerakan berbasis arah kamera (head direction)

---

###  Camera Control

* Mouse untuk mengatur arah pandang:

  * Horizontal (Yaw) → rotasi `Head`
  * Vertical (Pitch) → rotasi `Camera3D`
* Sudut kamera dibatasi agar tidak over-rotate

---

###  Sprint System

* Tombol: **Shift**
* Meningkatkan kecepatan movement
* Terintegrasi dengan sistem movement utama

---

###  Dynamic FOV (Field of View)

* FOV meningkat saat sprint
* Transisi smooth menggunakan `lerp`
* Memberikan efek “sense of speed”

---

### Crouch System

* Tombol: **Ctrl**
* Mengurangi tinggi player dan posisi kamera
* Movement menjadi lebih lambat saat crouch
* **Edge Case Handling:**

  * Tidak bisa sprint saat crouch
  * Tidak bisa berdiri jika ada obstacle di atas (ceiling check)

---

###  Scene Transition System

* Menggunakan `Area3D` sebagai trigger
* Saat player masuk area → pindah scene otomatis
* Scene path dapat diatur secara fleksibel

## 🎮 Controls

| Input   | Aksi          |
| ------- | ------------- |
| W A S D | Movement      |
| Shift   | Sprint        |
| Ctrl    | Crouch        |
| Space   | Jump          |

---



Zillan Ahmad Ryandi
