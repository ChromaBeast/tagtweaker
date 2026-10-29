#!/usr/bin/env python3
"""Seed the Firestore `products` catalog from a JSON file.

The app treats the catalog as read-only (see firestore.rules), so products
are written with admin privileges from here.

Usage:
  # Local emulator (no credentials needed):
  firebase emulators:start --only firestore --project demo-tagtweaker
  python scripts/seed_products.py --emulator

  # Real project (service account key from the Firebase console):
  python scripts/seed_products.py --credentials service-account.json

  # Check the data file without writing anything:
  python scripts/seed_products.py --dry-run
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_DATA = ROOT / "data" / "products.json"
COLLECTION = "products"
# Firestore allows 500 writes per batch; stay below it.
BATCH_SIZE = 400

REQUIRED_FIELDS = {"id", "title", "price", "category", "thumbnail"}


def load_products(path: Path) -> list[dict]:
    products = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(products, list):
        raise ValueError(f"{path} must contain a JSON list")

    seen: set[str] = set()
    for i, product in enumerate(products):
        missing = REQUIRED_FIELDS - product.keys()
        if missing:
            raise ValueError(f"product #{i} is missing {sorted(missing)}")
        if not isinstance(product["price"], (int, float)) or product["price"] < 0:
            raise ValueError(f"product {product['id']} has an invalid price")
        doc_id = str(product["id"])
        if doc_id in seen:
            raise ValueError(f"duplicate product id {doc_id}")
        seen.add(doc_id)
    return products


def connect(args: argparse.Namespace):
    if args.emulator:
        os.environ.setdefault("FIRESTORE_EMULATOR_HOST", args.emulator_host)
        from google.cloud import firestore  # bundled with firebase-admin

        return firestore.Client(project=args.project)

    import firebase_admin
    from firebase_admin import credentials, firestore

    firebase_admin.initialize_app(credentials.Certificate(args.credentials))
    return firestore.client()


def seed(db, products: list[dict]) -> None:
    batch = db.batch()
    pending = 0
    for product in products:
        # Product id doubles as the document id (document ids must be strings).
        ref = db.collection(COLLECTION).document(str(product["id"]))
        batch.set(ref, product)
        pending += 1
        if pending == BATCH_SIZE:
            batch.commit()
            batch = db.batch()
            pending = 0
    if pending:
        batch.commit()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--file", type=Path, default=DEFAULT_DATA)
    target = parser.add_mutually_exclusive_group()
    target.add_argument("--emulator", action="store_true", help="write to the local emulator")
    target.add_argument("--credentials", default="service-account.json", help="service account key")
    target.add_argument("--dry-run", action="store_true", help="validate the data only")
    parser.add_argument("--emulator-host", default="127.0.0.1:8080")
    parser.add_argument("--project", default="demo-tagtweaker", help="project id for --emulator")
    args = parser.parse_args(argv)

    try:
        products = load_products(args.file)
    except (OSError, ValueError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    if args.dry_run:
        print(f"{len(products)} products in {args.file} look valid.")
        return 0

    seed(connect(args), products)
    where = f"emulator {os.environ['FIRESTORE_EMULATOR_HOST']}" if args.emulator else "Firestore"
    print(f"Seeded {len(products)} products into {where}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
