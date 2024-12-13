# Content Curator

A modern content curation platform built with Next.js, FastAPI, and Supabase. This application allows users to collect, organize, and remix content from various sources.

## Features

- Content ingestion from multiple sources
- Content organization with tags
- Content remixing capabilities
- Modern, responsive UI built with Next.js and Tailwind CSS
- Secure data storage with Supabase

## Tech Stack

### Frontend
- Next.js
- React
- Tailwind CSS
- React Beautiful DND
- Supabase Client

### Backend
- FastAPI
- Supabase (PostgreSQL)
- Python

## Getting Started

1. Clone the repository:
```bash
git clone [your-repo-url]
cd content-curator
```

2. Install frontend dependencies:
```bash
cd frontend
npm install
```

3. Set up environment variables:
Create a `.env.local` file in the frontend directory with:
```
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
```

4. Run the development server:
```bash
npm run dev
```

5. Initialize the database:
Run the SQL migration files in the following order:
- `00-initial-schema.sql`
- `02-public-access.sql`
- `01-test-data.sql`

## Project Structure

```
content-curator/
├── frontend/           # Next.js frontend application
│   ├── src/
│   │   ├── app/       # Next.js app directory
│   │   ├── components/# React components
│   │   └── utils/     # Utility functions
│   └── public/        # Static assets
├── supabase/
│   └── migrations/    # Database migrations
└── README.md
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
