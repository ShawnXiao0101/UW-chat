package main

import (
	"fmt"
	"kama_chat_server/internal/config"
	"kama_chat_server/internal/https_server"
	"kama_chat_server/internal/service/chat"
	"kama_chat_server/internal/service/kafka"
	myredis "kama_chat_server/internal/service/redis"
	"kama_chat_server/pkg/zlog"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	//getConfig读取config.yaml文件中的配置信息，返回一个结构体，以供后续使用。
	conf := config.GetConfig()
	host := conf.MainConfig.Host
	port := conf.MainConfig.Port
	kafkaConfig := conf.KafkaConfig
	//判断配置文件里 messageMode 的值，决定用哪种消息系统
	//如果 messageMode 是 "kafka"，则使用kafka消息队列，适用于大规模分布式系统。
	if kafkaConfig.MessageMode == "kafka" {
		kafka.KafkaService.KafkaInit()
	}
	//如果 messageMode 是 "channel"，则使用Go的channel机制，适用于小规模或单机应用。
	if kafkaConfig.MessageMode == "channel" {
		go chat.ChatServer.Start()
	} else {
		go chat.KafkaChatServer.Start()
	}

	go func() {
		// macOS本地部署
		if err := https_server.GE.RunTLS(fmt.Sprintf("%s:%d", host, port), "/Users/shawn/Desktop/UW-chat/KamaChat/pkg/ssl/127.0.0.1+1.pem", "/Users/shawn/Desktop/UW-chat/KamaChat/pkg/ssl/127.0.0.1+1-key.pem"); err != nil {
			zlog.Fatal("server running fault")
			return
		}
		// Ubuntu22.04云服务器部署
		// if err := https_server.GE.RunTLS(fmt.Sprintf("%s:%d", host, port), "/etc/ssl/certs/server.crt", "/etc/ssl/private/server.key"); err != nil {
		// 	zlog.Fatal("server running fault")
		// 	return
		// }
	}()
	
	//主程序阻塞等待，直到接收到系统信号（如SIGINT或SIGTERM）时才继续执行后续的清理和关闭操作。
	// 设置信号监听
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	// 等待信号
	<-quit

	if kafkaConfig.MessageMode == "kafka" {
		kafka.KafkaService.KafkaClose()
	}

	chat.ChatServer.Close()

	zlog.Info("关闭服务器...")

	// 删除所有Redis键
	if err := myredis.DeleteAllRedisKeys(); err != nil {
		zlog.Error(err.Error())
	} else {
		zlog.Info("所有Redis键已删除")
	}

	zlog.Info("服务器已关闭")

}
