package dao

import (
	"kama_chat_server/internal/dao"
	"kama_chat_server/internal/model"
	"kama_chat_server/pkg/util/random"
	"strconv"
	"testing"
	"time"
)

func TestCreate(t *testing.T) {
	userInfo := &model.UserInfo{
		Uuid:      "U" + strconv.Itoa(random.GetRandomInt(11)),
		Nickname:  "apylee",
		Telephone: "18032353211",
		Email:     "1212312312@qq.com",
		Password:  "123456",
		CreatedAt: time.Now(),
		IsAdmin:   0,
	}
	_ = dao.GormDB.Create(userInfo)
}
