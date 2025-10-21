import { ref, watch, type Ref } from 'vue'

/**
 * Composable to track if a form has been modified (dirty state)
 * Compares current form state with initial state using deep equality
 */
export function useFormDirty<T extends Record<string, unknown>>(formData: Ref<T>) {
  const isDirty = ref(false)
  const initialData = ref<T | null>(null)

  /**
   * Reset the dirty state and capture current form data as initial state
   */
  function resetDirty() {
    initialData.value = JSON.parse(JSON.stringify(formData.value))
    isDirty.value = false
  }

  /**
   * Mark form as clean without changing initial state
   */
  function markClean() {
    isDirty.value = false
  }

  /**
   * Check if form has been modified
   */
  function checkDirty() {
    if (!initialData.value) {
      isDirty.value = false
      return
    }

    isDirty.value = JSON.stringify(formData.value) !== JSON.stringify(initialData.value)
  }

  // Watch for changes in form data
  watch(
    formData,
    () => {
      checkDirty()
    },
    { deep: true }
  )

  // Initialize with current form data
  resetDirty()

  return {
    isDirty,
    resetDirty,
    markClean,
  }
}
