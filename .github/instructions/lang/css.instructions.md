---
applyTo: "**/*.css"
---

# CSS Coding Standards & Best Practices

## Directory & File Organization

- **All CSS files must be placed in the `src/styles/` subfolder.**
  - If a style is specific to a component or page, create a dedicated CSS file in `src/styles/` (e.g., `src/styles/ComponentName.css`).
  - Avoid inline styles and `<style>` blocks in markup files unless absolutely necessary.

## General Guidelines

- **Use native HTML tags for styling whenever possible.**
  - Prefer targeting semantic tags (`header`, `nav`, `main`, `section`, `article`, `footer`, etc.) over generic classes.
  - Use classes for reusable or component-specific styles.

- **Always use Flexbox for layout; avoid CSS Grid.**
  - Use Flexbox for all layout needs, including alignment, spacing, and responsive design.
  - Do not use CSS Grid in any styles.

- **Use CSS nesting for all element-specific and pseudo-selector styles.**
  - Nest child elements, pseudo-classes (`:hover`, `:focus`, etc.), and pseudo-elements (`::before`, `::after`) under their parent selector.
  - Example:
    ```css
    .button {
      color: var(--primary);
      &:hover {
        background: var(--primary-bg);
      }
      &::after {
        content: '';
      }
    }
    ```

- **Organize styles by feature or component.**
  - Group related styles together.
  - Use clear, descriptive class names (BEM or project convention).

- **Use CSS custom properties (variables) for colors, spacing, and other design tokens.**
  - Define variables at the `:root` level for global use.

- **Minimize use of `!important`.**
  - Only use when absolutely necessary and document the reason.

- **Prefer logical properties for layout.**
  - Use `margin-block`, `padding-inline`, etc., for better adaptability.

- **Avoid excessive specificity and deep nesting.**
  - Keep selectors as flat as possible for maintainability.

- **Document non-obvious or complex styles with comments.**

## Example Structure

## Example: CSS Nesting & Native Tag Usage

```css
main {
  padding: 2rem;
  section {
    margin-bottom: 2rem;
    h2 {
      font-size: 1.5rem;
      &:hover {
        color: var(--accent);
      }
    }
    p {
      color: var(--text-secondary);
    }
  }
}
```

---

> **Note:**
> Always use CSS nesting for element-specific and pseudo-selector rules.
> Place all CSS files in `src/styles/`.
> Prefer native HTML tags and semantic selectors for styling.
> Use Flexbox for all layout needs. Avoid CSS Grid.