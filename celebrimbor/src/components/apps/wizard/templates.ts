export interface AppTemplate {
  id: string
  name: string
  description: string
  icon: string
  runtime: string
  runtimeVersion: string
  framework: string
  buildCommand: string
  startCommand: string
  installCommand: string
  branch: string
  envVars?: Array<{ key: string; value: string }>
}

export const APP_TEMPLATES: AppTemplate[] = [
  {
    id: 'nextjs',
    name: 'Next.js App',
    description: 'React framework with server-side rendering and static generation',
    icon: '⚡',
    runtime: 'nodejs',
    runtimeVersion: '20',
    framework: 'Next.js 14',
    buildCommand: 'npm run build',
    startCommand: 'npm start',
    installCommand: 'npm install',
    branch: 'main'
  },
  {
    id: 'rails-api',
    name: 'Rails API',
    description: 'Ruby on Rails RESTful API with PostgreSQL',
    icon: '💎',
    runtime: 'ruby',
    runtimeVersion: '3.3',
    framework: 'Rails 8',
    buildCommand: 'bundle install && rails assets:precompile',
    startCommand: 'rails server',
    installCommand: 'bundle install',
    branch: 'main',
    envVars: [
      { key: 'RAILS_ENV', value: 'production' },
      { key: 'DATABASE_URL', value: '' }
    ]
  },
  {
    id: 'vue-spa',
    name: 'Vue 3 SPA',
    description: 'Vue 3 single-page application with Vite',
    icon: '🟢',
    runtime: 'nodejs',
    runtimeVersion: '20',
    framework: 'Vue 3 + Vite',
    buildCommand: 'npm run build',
    startCommand: 'npm run preview',
    installCommand: 'npm install',
    branch: 'main'
  },
  {
    id: 'django',
    name: 'Python Django',
    description: 'Django web framework with PostgreSQL',
    icon: '🐍',
    runtime: 'python',
    runtimeVersion: '3.12',
    framework: 'Django 5',
    buildCommand: 'pip install -r requirements.txt && python manage.py migrate',
    startCommand: 'gunicorn config.wsgi',
    installCommand: 'pip install -r requirements.txt',
    branch: 'main',
    envVars: [
      { key: 'DJANGO_SETTINGS_MODULE', value: 'config.settings.production' },
      { key: 'DATABASE_URL', value: '' }
    ]
  },
  {
    id: 'express',
    name: 'Express API',
    description: 'Node.js Express REST API',
    icon: '🚂',
    runtime: 'nodejs',
    runtimeVersion: '20',
    framework: 'Express',
    buildCommand: 'npm install',
    startCommand: 'node server.js',
    installCommand: 'npm install',
    branch: 'main'
  },
  {
    id: 'static',
    name: 'Static Site',
    description: 'Static HTML/CSS/JS site',
    icon: '📄',
    runtime: 'nodejs',
    runtimeVersion: '20',
    framework: 'None',
    buildCommand: 'npm run build',
    startCommand: 'npx serve dist',
    installCommand: 'npm install',
    branch: 'main'
  }
]

export const RUNTIME_OPTIONS = [
  { value: 'nodejs', label: 'Node.js', versions: ['20', '18', '16'] },
  { value: 'python', label: 'Python', versions: ['3.12', '3.11', '3.10'] },
  { value: 'ruby', label: 'Ruby', versions: ['3.3', '3.2', '3.1'] },
  { value: 'go', label: 'Go', versions: ['1.21', '1.20', '1.19'] },
  { value: 'php', label: 'PHP', versions: ['8.3', '8.2', '8.1'] },
  { value: 'java', label: 'Java', versions: ['21', '17', '11'] },
  { value: 'dotnet', label: '.NET', versions: ['8.0', '7.0', '6.0'] }
]

export const FRAMEWORK_OPTIONS: Record<string, string[]> = {
  nodejs: ['Next.js', 'Express', 'Nest.js', 'Vue', 'React', 'Svelte', 'Nuxt', 'None'],
  python: ['Django', 'Flask', 'FastAPI', 'None'],
  ruby: ['Rails', 'Sinatra', 'None'],
  go: ['Gin', 'Echo', 'Fiber', 'None'],
  php: ['Laravel', 'Symfony', 'None'],
  java: ['Spring Boot', 'Micronaut', 'None'],
  dotnet: ['ASP.NET Core', 'Blazor', 'None']
}
