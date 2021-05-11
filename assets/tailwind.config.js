module.exports = {
  purge: {
    enabled: false,
    layers: ['components', 'utilities'],
    content: [
    "../lib/**/*.eex",
      "../lib/**/*.leex",
      "../lib/**/*_view.ex"
    ],
    preserveHtmlElements: false,
    css: ['./css/*.scss'],
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
