import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import LoginView from '../views/LoginView.vue'
import SignupView from '../views/SignupView.vue'
import DashboardLayout from '../views/DashboardLayout.vue'
import HomePage from '../views/Dashboard/HomePage.vue'
import ProductsListPage from '../views/Products/ProductsListPage.vue'
import ProductFormPage from '../views/Products/ProductFormPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/dashboard'
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: { requiresGuest: true }
    },
    {
      path: '/signup',
      name: 'signup',
      component: SignupView,
      meta: { requiresGuest: true }
    },
    {
      path: '/',
      component: DashboardLayout,
      meta: { requiresAuth: true },
      children: [
        {
          path: 'dashboard',
          name: 'dashboard',
          component: HomePage
        },
        {
          path: 'products',
          name: 'products',
          component: ProductsListPage
        },
        {
          path: 'products/new',
          name: 'products-new',
          component: ProductFormPage
        },
        {
          path: 'products/:id/edit',
          name: 'products-edit',
          component: ProductFormPage
        },
        {
          path: 'companies',
          name: 'companies',
          component: () => import('../views/Companies/CompaniesListPage.vue')
        },
        {
          path: 'warehouses',
          name: 'warehouses',
          component: () => import('../views/Warehouses/WarehousesListPage.vue')
        }
      ]
    }
  ],
})

// Navigation guard
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    // Redirect to login if trying to access protected route
    next({ name: 'login' })
  } else if (to.meta.requiresGuest && authStore.isAuthenticated) {
    // Redirect to dashboard if already logged in
    next({ name: 'dashboard' })
  } else {
    next()
  }
})

export default router
