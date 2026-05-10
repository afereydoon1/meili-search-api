# Meili Search Setup

## Prerequisites

To use the provided `make` commands on Windows, you need to have **Chocolatey** installed first, and then install **Make** via Chocolatey:

```sh
choco install make
```

## Setup

1. **Clone the repository**:

```sh
git clone https://github.com/afereydoon1/meili-search-api.git
cd meili-search-api
```

2. **Copy environment file**:

```sh
cp .env.example .env
```

3. **Configure environment variables**  
   Open `.env` and set all required variables (database, cache, etc.).

## Build & Migrate

1. **Build the project**:

```sh
make build
```

```sh
make up
```

```sh
npm run dev
```

2. **Run migrations**:

```sh
make artisan cmd="migrate"
```

3. **Seed database with large dataset**:

```sh
make artisan cmd="db:seed --class=LargeUserSeeder"
```

4. **Start queue worker for seeding**:

```sh
make artisan cmd="queue:work redis --queue=seeding --sleep=1"
```

5. **Index Users to Meilisearch**

This command reindexes all users in Meilisearch:

```sh
make artisan cmd="reindex:users"
```

✅ Now your project should be ready

## 🤝 Contribution

Pull requests are welcome. Please fork the repository and open a PR

## 📄 License

[MIT License](https://opensource.org/licenses/MIT)

## Author

Fereydoon Salemi