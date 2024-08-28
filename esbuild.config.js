const esbuild = require('esbuild');
const path = require('path');

const isWatchMode = process.argv.includes('--watch');

const config = {
  entryPoints: ['app/javascript/application.js'], // 入口文件
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: path.join('app', 'assets', 'builds'),
  publicPath: 'public/assets',
  loader: { '.js': 'jsx', '.css': 'css', '.scss': 'css' }, // 處理文件類型
  minify: process.env.NODE_ENV === 'production',
};

if (isWatchMode) {
  esbuild.context(config).then(ctx => {
    ctx.watch();
  }).catch(() => process.exit(1));
} else {
  esbuild.build(config).catch(() => process.exit(1));
}
