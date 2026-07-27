import { defineConfig } from "oxlint";

export default defineConfig({
  categories: {
    correctness: "deny",
    restriction: "deny",
    suspicious: "deny",
    pedantic: "warn",
    perf: "deny",
  },
  env: {
    node: true,
    astro: true,
    worker: true,
    vitest: true,
    browser: true,
    builtin: true,
    serviceworker: true,
  },
  options: {
    typeAware: true,
    typeCheck: true,
  },
  plugins: [
    "eslint",
    "import",
    "jsdoc",
    "jsx-a11y",
    "node",
    "oxc",
    "promise",
    "typescript",
    "react",
    "react-perf",
    "unicorn",
    "vitest",
  ],
  rules: {
    "react/button-has-type": ["off"],
    "react/react-in-jsx-scope": ["off"],
    "react/only-export-components": ["off"],
    "react/forbid-component-props": ["off"],
    "react/no-multi-comp": ["deny", { ignoreStateless: true }],
    "react/jsx-filename-extension": ["deny", { extensions: ["jsx", "tsx"] }],
    "oxc/no-optional-chaining": ["off"],
    "oxc/no-rest-spread-properties": ["off"],
  },
});
