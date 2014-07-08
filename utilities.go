package main

import (
	"errors"
	"github.com/gorilla/mux"
	"net/http"
	"strconv"
)

// Helper func so less code is duplicated here.
func GetServerFromRequest(req *http.Request) (server *Server, err error) {
	// Figure out what {id} is in "/server/{id}"
	id, err := strconv.ParseUint(mux.Vars(req)["id"], 10, 16)
	if err != nil {
		warnf("Error converting server id: %s", err)
	}

	// Get our server from our slice of servers
	for _, s := range clients {
		if s.ID == uint16(id) {
			return s, nil
		}
	}

	return nil, errors.New("Could not find server")
}