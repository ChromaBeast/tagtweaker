import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# 1. Initialize Firebase Admin
# Replace 'serviceAccountKey.json' with the path to your downloaded key file
cred = credentials.Certificate("service-account.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
collection_name = "products"

# 2. Your Data (Paste the full JSON list here)
products_data = [
  {
    "id": 21,
    "title": "Sony WH-1000XM6",
    "brand": "Sony",
    "category": "Audio",
    "description": "Industry-leading noise canceling with Dual Noise Sensor technology. Next-level music with Edge-AI, co-developed with Sony Music Studios Tokyo. Up to 30-hour battery life with quick charging.",
    "price": 29990,
    "discountPercentage": 12,
    "rating": 4.8,
    "stock": 85,
    "thumbnail": "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.sony.co.in/electronics/headband-headphones/wh-1000xm5",
    "images": [
      "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1599669454699-24889362302a?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": True,
      "isTrending": True
    }
  },
  {
    "id": 22,
    "title": "AirPods Pro (3rd Gen)",
    "brand": "Apple",
    "category": "Audio",
    "description": "Features the H3 headphone chip. Active Noise Cancellation reduces unwanted background noise. Adaptive Transparency lets outside sounds in while reducing loud environmental noise.",
    "price": 24900,
    "discountPercentage": 5,
    "rating": 4.9,
    "stock": 210,
    "thumbnail": "https://images.unsplash.com/photo-1603351154351-5cf020c69a52?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.apple.com/in/airpods-pro/",
    "images": [
      "https://images.unsplash.com/photo-1603351154351-5cf020c69a52?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1629367494173-c78a56567877?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": True
    }
  },
  {
    "id": 23,
    "title": "JBL Flip 7",
    "brand": "JBL",
    "category": "Audio",
    "description": "Bold JBL Original Pro Sound with dual pumping bass radiators. IP67 waterproof and dustproof. 15 hours of playtime and PartyBoost compatible to link multiple speakers.",
    "price": 11999,
    "discountPercentage": 15,
    "rating": 4.6,
    "stock": 150,
    "thumbnail": "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://in.jbl.com/bluetooth-speakers/",
    "images": [
      "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1543512214-318c77a07232?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": False
    }
  },
  {
    "id": 24,
    "title": "Sennheiser HD 450BT",
    "brand": "Sennheiser",
    "category": "Audio",
    "description": "Great wireless sound with deep dynamic bass and high-quality codec support including AAC and AptX Low Latency. 30-hour battery life and intuitive controls.",
    "price": 8990,
    "discountPercentage": 20,
    "rating": 4.4,
    "stock": 45,
    "thumbnail": "https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://en-in.sennheiser.com/hd-450-bt",
    "images": [
      "https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1484704849700-f032a568e944?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": False
    }
  },
  {
    "id": 25,
    "title": "Marshall Stanmore III",
    "brand": "Marshall",
    "category": "Audio",
    "description": "The legendary one, reimagined with a wider soundstage. Features classic Marshall design, Bluetooth 5.2, and RCA inputs for analog connectivity.",
    "price": 34999,
    "discountPercentage": 0,
    "rating": 4.9,
    "stock": 20,
    "thumbnail": "https://images.unsplash.com/photo-1623750858348-5d7198856249?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.marshallheadphones.com/in/en/",
    "images": [
      "https://images.unsplash.com/photo-1623750858348-5d7198856249?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1612658596525-e7039838446b?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": True,
      "isTrending": True
    }
  },
  {
    "id": 26,
    "title": "DualSense Wireless Controller",
    "brand": "Sony",
    "category": "Controllers",
    "description": "Discover a deeper, highly immersive gaming experience that brings the action to life in the palms of your hands. Features haptic feedback and adaptive triggers.",
    "price": 5990,
    "discountPercentage": 8,
    "rating": 4.8,
    "stock": 300,
    "thumbnail": "https://images.unsplash.com/photo-1606318801954-d46d46d3360a?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.playstation.com/en-in/accessories/dualsense-wireless-controller/",
    "images": [
      "https://images.unsplash.com/photo-1606318801954-d46d46d3360a?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1586723916590-473e353b76b3?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": True
    }
  },
  {
    "id": 27,
    "title": "Xbox Wireless Controller - Carbon Black",
    "brand": "Microsoft",
    "category": "Controllers",
    "description": "Experience the modernized design of the Xbox Wireless Controller, featuring sculpted surfaces and refined geometry for enhanced comfort during gameplay.",
    "price": 5390,
    "discountPercentage": 10,
    "rating": 4.7,
    "stock": 180,
    "thumbnail": "https://images.unsplash.com/photo-1621259182978-fbf93132d53d?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.xbox.com/en-IN/accessories/controllers/xbox-wireless-controller",
    "images": [
      "https://images.unsplash.com/photo-1621259182978-fbf93132d53d?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1605901309584-818e25960b8f?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": False
    }
  },
  {
    "id": 28,
    "title": "Logitech G29 Racing Wheel",
    "brand": "Logitech",
    "category": "Controllers",
    "description": "The definitive sim racing wheel for PlayStation and PC. Realistic force feedback, helical gearing, and stainless steel paddle shifters.",
    "price": 29995,
    "discountPercentage": 25,
    "rating": 4.6,
    "stock": 40,
    "thumbnail": "https://images.unsplash.com/photo-1547658719-da2b51169166?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.logitechg.com/en-in/products/driving/driving-force-racing-wheel.html",
    "images": [
      "https://images.unsplash.com/photo-1547658719-da2b51169166?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1635334276626-797a1a228952?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": True,
      "isTrending": False
    }
  },
  {
    "id": 29,
    "title": "Razer Kishi V2",
    "brand": "Razer",
    "category": "Controllers",
    "description": "Universal mobile gaming controller for Android. Console-class controls, ultra-low latency, and pass-through charging.",
    "price": 9999,
    "discountPercentage": 0,
    "rating": 4.4,
    "stock": 95,
    "thumbnail": "https://images.unsplash.com/photo-1593118247619-e2d6f056869e?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.razer.com/mobile-controllers/razer-kishi-v2",
    "images": [
      "https://images.unsplash.com/photo-1593118247619-e2d6f056869e?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1600080972464-8a5d35f63d60?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": False
    }
  },
  {
    "id": 30,
    "title": "8BitDo Pro 2",
    "brand": "8BitDo",
    "category": "Controllers",
    "description": "Retro-inspired controller with modern features. Two pro-level back buttons, custom profile switching, and motion control support.",
    "price": 4499,
    "discountPercentage": 5,
    "rating": 4.8,
    "stock": 120,
    "thumbnail": "https://images.unsplash.com/photo-1629426534907-43d5023552a9?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.8bitdo.com/pro2/",
    "images": [
      "https://images.unsplash.com/photo-1629426534907-43d5023552a9?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1581604556328-b56544149466?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": True
    }
  },
  {
    "id": 31,
    "title": "LG C5 OLED evo 55\"",
    "brand": "LG",
    "category": "Televisions",
    "description": "Advanced OLED evo panel with Brightness Booster Max. Alpha 10 AI Processor 4K Gen7, Dolby Vision IQ, and Dolby Atmos for cinematic immersion.",
    "price": 149990,
    "discountPercentage": 18,
    "rating": 4.9,
    "stock": 60,
    "thumbnail": "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.lg.com/in/tvs",
    "images": [
      "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1577979749830-f1d742b96791?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": True,
      "isTrending": True
    }
  },
  {
    "id": 32,
    "title": "Samsung Neo QLED 8K",
    "brand": "Samsung",
    "category": "Televisions",
    "description": "Quantum Matrix Technology Pro with Mini LEDs. Neural Quantum Processor 8K creates the best viewing experience with AI upscaling.",
    "price": 319990,
    "discountPercentage": 10,
    "rating": 4.7,
    "stock": 25,
    "thumbnail": "https://images.unsplash.com/photo-1601944179066-29786cb9d32a?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.samsung.com/in/tvs/qled-tv/",
    "images": [
      "https://images.unsplash.com/photo-1601944179066-29786cb9d32a?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1593784653277-8d36824566eb?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": True,
      "isTrending": False
    }
  },
  {
    "id": 33,
    "title": "Sony Bravia XR A80L",
    "brand": "Sony",
    "category": "Televisions",
    "description": "Cognitive Processor XR understands how humans see and hear. Acoustic Surface Audio+ turns the entire screen into a speaker.",
    "price": 189900,
    "discountPercentage": 5,
    "rating": 4.8,
    "stock": 40,
    "thumbnail": "https://images.unsplash.com/photo-1552975084-6e027cd345c2?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.sony.co.in/electronics/tv/tvs",
    "images": [
      "https://images.unsplash.com/photo-1552975084-6e027cd345c2?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1567690187548-f07b1d7bf5a9?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": True
    }
  },
  {
    "id": 34,
    "title": "Mi X Series 50\"",
    "brand": "Xiaomi",
    "category": "Televisions",
    "description": "4K Dolby Vision display with 30W Dolby Audio. Metal bezel-less design and Google TV integration for seamless streaming.",
    "price": 32999,
    "discountPercentage": 15,
    "rating": 4.5,
    "stock": 350,
    "thumbnail": "https://images.unsplash.com/photo-1560169897-fc0cdbdfa4d5?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.mi.com/in/product-list/tv-smart-home/",
    "images": [
      "https://images.unsplash.com/photo-1560169897-fc0cdbdfa4d5?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1461151304267-38535e780c79?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": False
    }
  },
  {
    "id": 35,
    "title": "TCL 65\" Google TV",
    "brand": "TCL",
    "category": "Televisions",
    "description": "QLED technology with wide color gamut. 120Hz Game Accelerator and AMD FreeSync technology for smoother gaming.",
    "price": 64990,
    "discountPercentage": 22,
    "rating": 4.3,
    "stock": 100,
    "thumbnail": "https://images.unsplash.com/photo-1509281373149-e957c629640d?auto=format&fit=crop&w=500&q=80",
    "product_url": "https://www.tcl.com/in/en/tvs",
    "images": [
      "https://images.unsplash.com/photo-1509281373149-e957c629640d?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?auto=format&fit=crop&w=800&q=80"
    ],
    "ui": {
      "carousel": False,
      "isTrending": True
    }
  }
]

def upload_products(data):
    batch = db.batch()
    count = 0
    total_batches = 0

    print(f"Starting upload of {len(data)} products...")

    for product in data:
        # We use the product 'id' as the document ID in Firestore
        # Convert id to string because document IDs must be strings
        doc_ref = db.collection(collection_name).document(str(product["id"]))
        batch.set(doc_ref, product)
        count += 1

        # Firestore batches allow up to 500 operations. 
        # Committing every 400 to be safe.
        if count >= 400:
            batch.commit()
            print(f"Committed batch of {count} items.")
            batch = db.batch() # Start a new batch
            count = 0
            total_batches += 1

    # Commit any remaining items
    if count > 0:
        batch.commit()
        print(f"Committed final batch of {count} items.")

    print("Upload complete!")

if __name__ == "__main__":
    # If you pasted the partial list above, make sure to use the FULL list
    # from the previous message before running.
    upload_products(products_data)