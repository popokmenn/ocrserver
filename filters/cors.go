package filters

import (
	"net/http"

	"github.com/otiai10/marmoset"
)

// CORSFilter represents a filter to handle CORS
type CORSFilter struct{}

// Before adds CORS headers to the response
func (f *CORSFilter) Before(c *marmoset.Context) error {
	c.Response().Header().Set("Access-Control-Allow-Origin", "*")
	c.Response().Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	c.Response().Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

	// Handle preflight requests
	if c.Request().Method == "OPTIONS" {
		c.Response().WriteHeader(http.StatusOK)
		return nil
	}

	return nil
}

// After is called after the handler
func (f *CORSFilter) After(c *marmoset.Context) error {
	return nil
}
