console.log('env', process.env.NODE_ENV)
module.exports = {
  purge: {
    enabled: process.env.NODE_ENV === 'production',
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
