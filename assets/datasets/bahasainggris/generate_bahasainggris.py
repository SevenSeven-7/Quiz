import json
import random

questions_list = []
q_id = 1

def add_q(text, correct, options):
    global q_id
    opts = options.copy()
    if correct not in opts:
        opts.append(correct)
        
    unique_opts = []
    for o in opts:
        if o not in unique_opts:
            unique_opts.append(o)
    opts = unique_opts
    
    while len(opts) < 4:
        opts.append("Wrong Option " + str(random.randint(1,1000)))
    
    if len(opts) > 4:
        opts.remove(correct)
        opts = random.sample(opts, 3)
        opts.append(correct)

    random.shuffle(opts)
    
    q = {
        "text": text,
        "correctAnswer": correct,
        "options": opts,
        "type": "multiple_choice",
        "correctAnswerIndex": opts.index(correct)
    }
    questions_list.append(q)

vocab_data = {
    # Animals (50)
    "Kucing": "Cat", "Anjing": "Dog", "Burung": "Bird", "Ikan": "Fish", "Singa": "Lion",
    "Harimau": "Tiger", "Gajah": "Elephant", "Kuda": "Horse", "Sapi": "Cow", "Kambing": "Goat",
    "Domba": "Sheep", "Babi": "Pig", "Ayam": "Chicken", "Bebek": "Duck", "Kelinci": "Rabbit",
    "Monyet": "Monkey", "Ular": "Snake", "Buaya": "Crocodile", "Katak": "Frog", "Kura-kura": "Turtle",
    "Lumba-lumba": "Dolphin", "Paus": "Whale", "Hiu": "Shark", "Kepiting": "Crab", "Cumi-cumi": "Squid",
    "Laba-laba": "Spider", "Semut": "Ant", "Kupu-kupu": "Butterfly", "Lebah": "Bee", "Nyamuk": "Mosquito",
    "Lalat": "Fly", "Burung Hantu": "Owl", "Elang": "Eagle", "Penguin": "Penguin", "Beruang": "Bear",
    "Serigala": "Wolf", "Rusa": "Deer", "Jerapah": "Giraffe", "Zebra": "Zebra", "Badak": "Rhinoceros",
    "Kuda Nil": "Hippopotamus", "Kangguru": "Kangaroo", "Koala": "Koala", "Panda": "Panda", "Gorila": "Gorilla",
    "Kelelawar": "Bat", "Tikus": "Mouse", "Tupai": "Squirrel", "Landak": "Hedgehog", "Burung Merak": "Peacock",
    
    # Fruits (30)
    "Apel": "Apple", "Pisang": "Banana", "Jeruk": "Orange", "Anggur": "Grape", "Semangka": "Watermelon",
    "Mangga": "Mango", "Nanas": "Pineapple", "Stroberi": "Strawberry", "Melon": "Melon", "Pepaya": "Papaya",
    "Alpukat": "Avocado", "Kelapa": "Coconut", "Durian": "Durian", "Delima": "Pomegranate", "Manggis": "Mangosteen",
    "Lemon": "Lemon", "Kiwi": "Kiwi", "Pir": "Pear", "Ceri": "Cherry", "Plum": "Plum", "Sirsak": "Soursop", "Jambu Biji": "Guava",
    "Rambutan": "Rambutan", "Leci": "Lychee", "Kurma": "Date", "Tin": "Fig", "Nangka": "Jackfruit", "Mengkudu": "Noni",
    "Salak": "Snake fruit", "Duku": "Langsat",

    # Objects (60)
    "Meja": "Table", "Kursi": "Chair", "Pintu": "Door", "Jendela": "Window", "Lemari": "Cupboard",
    "Kasur": "Bed", "Bantal": "Pillow", "Guling": "Bolster", "Selimut": "Blanket", "Kipas Angin": "Fan",
    "Lampu": "Lamp", "Buku": "Book", "Pensil": "Pencil", "Pena": "Pen", "Penghapus": "Eraser",
    "Penggaris": "Ruler", "Tas": "Bag", "Sepatu": "Shoes", "Kaos Kaki": "Socks", "Baju": "Shirt",
    "Celana": "Pants", "Topi": "Hat", "Kacamata": "Glasses", "Jam Tangan": "Watch", "Jam Dinding": "Clock",
    "Telepon": "Telephone", "Televisi": "Television", "Kulkas": "Refrigerator", "Mesin Cuci": "Washing machine", "Setrika": "Iron",
    "Payung": "Umbrella", "Gelas": "Glass", "Piring": "Plate", "Sendok": "Spoon", "Garpu": "Fork",
    "Pisau": "Knife", "Ember": "Bucket", "Sapu": "Broom", "Handuk": "Towel", "Sabun": "Soap",
    "Sikat Gigi": "Toothbrush", "Pasta Gigi": "Toothpaste", "Sisir": "Comb", "Cermin": "Mirror", "Kunci": "Key",
    "Gembok": "Padlock", "Dompet": "Wallet", "Sabuk": "Belt", "Dasi": "Tie", "Jaket": "Jacket",
    "Mantel": "Coat", "Sarung Tangan": "Gloves", "Cincin": "Ring", "Kalung": "Necklace", "Gelang": "Bracelet",
    "Anting": "Earring", "Karpet": "Carpet", "Tirai": "Curtain", "Sofa": "Sofa", "Oven": "Oven",

    # Numbers (40)
    "1": "One", "2": "Two", "3": "Three", "4": "Four", "5": "Five", "6": "Six", "7": "Seven", "8": "Eight", "9": "Nine", "10": "Ten",
    "11": "Eleven", "12": "Twelve", "13": "Thirteen", "14": "Fourteen", "15": "Fifteen", "16": "Sixteen", "17": "Seventeen", "18": "Eighteen", "19": "Nineteen", "20": "Twenty",
    "21": "Twenty One", "22": "Twenty Two", "30": "Thirty", "40": "Forty", "50": "Fifty", "60": "Sixty", "70": "Seventy", "80": "Eighty", "90": "Ninety", "100": "One Hundred",
    "101": "One Hundred One", "200": "Two Hundred", "500": "Five Hundred", "1000": "One Thousand", "1000000": "One Million", "Pertama": "First", "Kedua": "Second", "Ketiga": "Third", "Keempat": "Fourth", "Kelima": "Fifth",

    # Colors (15)
    "Merah": "Red", "Biru": "Blue", "Kuning": "Yellow", "Hijau": "Green", "Hitam": "Black",
    "Putih": "White", "Cokelat": "Brown", "Abu-abu": "Gray", "Merah Muda": "Pink", "Ungu": "Purple",
    "Jingga": "Orange", "Emas": "Gold", "Perak": "Silver", "Bata": "Maroon", "Biru Dongker": "Navy",

    # Body Parts (25)
    "Kepala": "Head", "Rambut": "Hair", "Mata": "Eye", "Telinga": "Ear", "Hidung": "Nose",
    "Mulut": "Mouth", "Gigi": "Tooth", "Lidah": "Tongue", "Bibir": "Lip", "Pipi": "Cheek",
    "Dagu": "Chin", "Leher": "Neck", "Bahu": "Shoulder", "Lengan": "Arm", "Tangan": "Hand",
    "Jari": "Finger", "Dada": "Chest", "Perut": "Stomach", "Punggung": "Back", "Pinggang": "Waist",
    "Kaki (bawah)": "Foot", "Kaki (atas)": "Leg", "Lutut": "Knee", "Jari Kaki": "Toe", "Kuku": "Nail",

    # Family (20)
    "Ayah": "Father", "Ibu": "Mother", "Anak Laki-laki": "Son", "Anak Perempuan": "Daughter", "Saudara Laki-laki": "Brother",
    "Saudara Perempuan": "Sister", "Kakek": "Grandfather", "Nenek": "Grandmother", "Cucu Laki-laki": "Grandson", "Cucu Perempuan": "Granddaughter",
    "Paman": "Uncle", "Bibi": "Aunt", "Keponakan Laki-laki": "Nephew", "Keponakan Perempuan": "Niece", "Sepupu": "Cousin",
    "Suami": "Husband", "Istri": "Wife", "Mertua Laki-laki": "Father-in-law", "Mertua Perempuan": "Mother-in-law", "Anak Tiri": "Stepchild",

    # Professions (30)
    "Dokter": "Doctor", "Guru": "Teacher", "Polisi": "Police", "Tentara": "Soldier", "Perawat": "Nurse",
    "Petani": "Farmer", "Nelayan": "Fisherman", "Pedagang": "Merchant", "Penulis": "Writer", "Pelukis": "Painter",
    "Penyanyi": "Singer", "Aktor": "Actor", "Aktris": "Actress", "Pilot": "Pilot", "Pramugari": "Stewardess",
    "Sopir": "Driver", "Montir": "Mechanic", "Tukang Kayu": "Carpenter", "Tukang Cukur": "Barber", "Koki": "Chef",
    "Arsitek": "Architect", "Insinyur": "Engineer", "Ilmuwan": "Scientist", "Pengacara": "Lawyer", "Hakim": "Judge",
    "Wartawan": "Journalist", "Fotografer": "Photographer", "Pustakawan": "Librarian", "Astronot": "Astronaut", "Penari": "Dancer",

    # Vehicles (20)
    "Mobil": "Car", "Motor": "Motorcycle", "Sepeda": "Bicycle", "Bus": "Bus", "Truk": "Truck",
    "Kereta Api": "Train", "Pesawat Terbang": "Airplane", "Helikopter": "Helicopter", "Kapal Laut": "Ship", "Perahu": "Boat",
    "Kapal Selam": "Submarine", "Taksi": "Taxi", "Ambulans": "Ambulance", "Mobil Pemadam Kebakaran": "Fire engine", "Mobil Polisi": "Police car",
    "Traktor": "Tractor", "Kereta Kuda": "Carriage", "Kapal Feri": "Ferry", "Rakit": "Raft", "Balon Udara": "Hot air balloon",

    # Places (25)
    "Sekolah": "School", "Rumah Sakit": "Hospital", "Bank": "Bank", "Pasar": "Market", "Toko": "Shop",
    "Kantor Pos": "Post office", "Kantor Polisi": "Police station", "Stasiun": "Station", "Bandara": "Airport", "Pelabuhan": "Port",
    "Restoran": "Restaurant", "Hotel": "Hotel", "Museum": "Museum", "Perpustakaan": "Library", "Taman": "Park",
    "Pantai": "Beach", "Gunung": "Mountain", "Sungai": "River", "Hutan": "Forest", "Danau": "Lake",
    "Gua": "Cave", "Pulau": "Island", "Desa": "Village", "Kota": "City", "Ibu Kota": "Capital",

    # Verbs (40)
    "Makan": "Eat", "Minum": "Drink", "Tidur": "Sleep", "Bangun": "Wake", "Berjalan": "Walk",
    "Berlari": "Run", "Melompat": "Jump", "Duduk": "Sit", "Berdiri": "Stand", "Bicara": "Speak",
    "Mendengar": "Hear", "Melihat": "See", "Menulis": "Write", "Membaca": "Read", "Berpikir": "Think",
    "Belajar": "Study", "Mengajar": "Teach", "Bekerja": "Work", "Bermain": "Play", "Menyanyi": "Sing",
    "Menari": "Dance", "Memasak": "Cook", "Mencuci": "Wash", "Membersihkan": "Clean", "Membuka": "Open",
    "Menutup": "Close", "Menangis": "Cry", "Tertawa": "Laugh", "Tersenyum": "Smile", "Marah": "Angry",
    "Membeli": "Buy", "Menjual": "Sell", "Memberi": "Give", "Menerima": "Receive", "Membawa": "Bring",
    "Mengambil": "Take", "Mencari": "Search", "Menemukan": "Find", "Kehilangan": "Lose", "Menang": "Win",

    # Adjectives (35)
    "Besar": "Big", "Kecil": "Small", "Tinggi": "Tall", "Pendek": "Short", "Panjang": "Long",
    "Berat": "Heavy", "Ringan": "Light", "Cepat": "Fast", "Lambat": "Slow", "Panas": "Hot",
    "Dingin": "Cold", "Hangat": "Warm", "Sejuk": "Cool", "Kuat": "Strong", "Lemah": "Weak",
    "Kaya": "Rich", "Miskin": "Poor", "Muda": "Young", "Tua": "Old", "Baru": "New",
    "Bagus": "Good", "Buruk": "Bad", "Cantik": "Beautiful", "Tampan": "Handsome", "Jelek": "Ugly",
    "Pintar": "Smart", "Bodoh": "Stupid", "Bahagia": "Happy", "Sedih": "Sad", "Lapar": "Hungry",
    "Haus": "Thirsty", "Lelah": "Tired", "Rajin": "Diligent", "Malas": "Lazy", "Murah Hati": "Generous"
}
# Total words: 390.

v_vals = list(vocab_data.values())
for k, v in vocab_data.items():
    add_q(f"What is the English word for '{k}'?", v, random.sample(v_vals, 4))

# English Logic Analogies (40)
logic_analogies = [
    ("Car", "Road", "Train", "Track"), ("Bird", "Fly", "Fish", "Swim"), ("Pen", "Write", "Knife", "Cut"),
    ("Sun", "Day", "Moon", "Night"), ("Hot", "Cold", "Up", "Down"), ("Doctor", "Hospital", "Teacher", "School"),
    ("Eye", "See", "Ear", "Hear"), ("Lion", "Roar", "Dog", "Bark"), ("Apple", "Fruit", "Carrot", "Vegetable"),
    ("Thirsty", "Drink", "Hungry", "Eat"), ("Book", "Read", "Song", "Listen"), ("Happy", "Smile", "Sad", "Cry"),
    ("Winter", "Snow", "Summer", "Sun"), ("Cat", "Kitten", "Dog", "Puppy"), ("Tree", "Forest", "Sand", "Desert"),
    ("Clock", "Time", "Thermometer", "Temperature"), ("Oven", "Bake", "Stove", "Boil"), ("Finger", "Hand", "Toe", "Foot"),
    ("Tired", "Sleep", "Dirty", "Wash"), ("Good", "Bad", "Black", "White"), ("Cow", "Milk", "Bee", "Honey"),
    ("Rain", "Umbrella", "Sun", "Sunglasses"), ("Kangaroo", "Australia", "Panda", "China"), ("Baker", "Bread", "Butcher", "Meat"),
    ("Ship", "Ocean", "Airplane", "Sky"), ("Scissors", "Cut", "Glue", "Paste"), ("Towel", "Dry", "Soap", "Clean"),
    ("Ice", "Cold", "Fire", "Hot"), ("Circle", "Round", "Square", "Boxy"), ("Singer", "Sing", "Actor", "Act"),
    ("Bed", "Sleep", "Chair", "Sit"), ("Key", "Lock", "Password", "Account"), ("Gills", "Fish", "Lungs", "Human"),
    ("Wheels", "Car", "Wings", "Airplane"), ("Day", "Light", "Night", "Dark"), ("Feathers", "Bird", "Scales", "Fish"),
    ("Broom", "Sweep", "Mop", "Clean"), ("Morning", "Breakfast", "Evening", "Dinner"), ("Wood", "Tree", "Glass", "Sand"),
    ("Horse", "Gallop", "Frog", "Jump")
]
for a1, b1, a2, b2 in logic_analogies:
    add_q(f"Logic Analogy: {a1} is to {b1} as {a2} is to...", b2, [x[3] for x in logic_analogies if x[3] != b2])

# Riddles (20)
logic_riddles = [
    ("What has to be broken before you can use it?", "An egg", ["A glass", "A window", "A car"]),
    ("I’m tall when I’m young, and I’m short when I’m old. What am I?", "A candle", ["A tree", "A human", "A mountain"]),
    ("What month of the year has 28 days?", "All of them", ["February", "January", "None"]),
    ("What is full of holes but still holds water?", "A sponge", ["A bucket", "A net", "A cup"]),
    ("What goes up but never comes down?", "Your age", ["A balloon", "A bird", "The sun"]),
    ("The more of this there is, the less you see. What is it?", "Darkness", ["Light", "Fog", "Water"]),
    ("What has many keys but can’t open a single lock?", "A piano", ["A keyboard", "A map", "A safe"]),
    ("I shave every day, but my beard stays the same. What am I?", "A barber", ["A monkey", "A bear", "A lion"]),
    ("You see a boat filled with people, yet there isn’t a single person on board. How is that possible?", "They are all married", ["It's a ghost ship", "They are animals", "The boat is sinking"]),
    ("What has words, but never speaks?", "A book", ["A radio", "A television", "A parrot"]),
    ("What has hands but cannot clap?", "A clock", ["A doll", "A tree", "A robot"]),
    ("What can travel around the world while staying in a corner?", "A stamp", ["A coin", "An airplane", "A letter"]),
    ("What has an eye but cannot see?", "A needle", ["A potato", "A bat", "A blind man"]),
    ("I have branches, but no fruit, trunk or leaves. What am I?", "A bank", ["A river", "A family tree", "A library"]),
    ("What gets wetter as it dries?", "A towel", ["A sponge", "A cloth", "Water"]),
    ("What has a head and a tail but no body?", "A coin", ["A snake", "A worm", "A comet"]),
    ("What belongs to you, but other people use it more than you?", "Your name", ["Your house", "Your money", "Your car"]),
    ("What runs all around a backyard, yet never moves?", "A fence", ["A dog", "A child", "A lawnmower"]),
    ("What can you catch, but not throw?", "A cold", ["A ball", "A boomerang", "A frisbee"]),
    ("What has a neck but no head?", "A bottle", ["A shirt", "A guitar", "A giraffe"])
]
for q, a, opts in logic_riddles:
    add_q(f"Riddle: {q}", a, opts)

# Logic Sequencings (50 unique logic questions)
names_pool = ["John", "Mary", "David", "Sarah", "Michael", "Emma", "Tom", "Lisa", "Alice", "Bob", "Charlie", "Diana"]
for i in range(25):
    n1, n2, n3 = random.sample(names_pool, 3)
    add_q(f"Logic Sequence #{i+1}: If {n1} is taller than {n2}, and {n2} is taller than {n3}. Who is the tallest?", n1, [n2, n3, "Cannot be determined"])

for i in range(25):
    n1, n2, n3 = random.sample(names_pool, 3)
    add_q(f"Logic Age #{i+1}: If {n1} is older than {n2}, and {n3} is younger than {n2}. Who is the youngest?", n3, [n1, n2, "Everyone is the same age"])

random.shuffle(questions_list)
if len(questions_list) > 500:
    questions_list = questions_list[:500]

for i, q in enumerate(questions_list):
    q['id'] = f"bahasainggris_{i+1}"

db_path = 'c:/laragon/www/Quiz/assets/datasets/bahasainggris/database-bahasainggris.json'
with open(db_path, 'w', encoding='utf-8') as f:
    json.dump(questions_list, f, indent=2, ensure_ascii=False)

print(f"Generated EXACTLY {len(questions_list)} unique questions and saved to {db_path}.")
