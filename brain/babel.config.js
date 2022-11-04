function hasPreset(presets, preset) {
  return presets.some(p => (Array.isArray(p) ? p[0] === preset : p == preset));
}

module.exports = function (api) {
  const webpackerConfig = require('@rails/webpacker/package/babel/preset.js');
  const config = webpackerConfig(api);

  return {
    ...config,
    presets: [
      ...config.presets,
      !hasPreset(config.presets, '@babel/preset-react') && '@babel/preset-react',
      !hasPreset(config.presets, '@babel/preset-typescript') && '@babel/preset-typescript',
      '@emotion/babel-preset-css-prop',
    ].filter(Boolean),
  };
};
