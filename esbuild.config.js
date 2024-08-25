const esbuild = require('esbuild');

const isProduction = process.env.NODE_ENV === 'production';

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  minify: true,
  sourcemap: true,
  outdir: 'app/assets/builds',
  loader: { '.js': 'jsx', '.css': 'file' },
  treeShaking: false,
}).catch(() => process.exit(1));