const { defineConfig } = require('@vue/cli-service')
const fs = require('fs')
const path = require('path')
module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  devServer: (() => {
    const certPath = path.join(__dirname, 'src/assets/cert/127.0.0.1+1.pem')
    const keyPath  = path.join(__dirname, 'src/assets/cert/127.0.0.1+1-key.pem')
    const hasCert  = fs.existsSync(certPath) && fs.existsSync(keyPath)
    return {
      host: '0.0.0.0',
      // 此处开启 https,并加载本地证书（否则浏览器左上角会提示不安全）
      // cert 文件不存在时（如 CI 环境）自动降级为 http
      ...(hasCert ? {
        https: {
          cert: fs.readFileSync(certPath),
          key:  fs.readFileSync(keyPath),
        },
      } : {}),
      // macOS本地开发用8443，避免443需要sudo权限
      port: 8443,
    }
  })()
  // devServer: {
  //   host: '0.0.0.0',
  //   // 端口设为常见的开发用端口，避免与服务器默认的 HTTPS 端口冲突
  //   port: 8080,
  // }
})
