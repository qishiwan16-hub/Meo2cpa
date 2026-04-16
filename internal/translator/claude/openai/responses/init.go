package responses

import (
	. "github.com/router-for-me/Meo2cpa/v6/internal/constant"
	"github.com/router-for-me/Meo2cpa/v6/internal/interfaces"
	"github.com/router-for-me/Meo2cpa/v6/internal/translator/translator"
)

func init() {
	translator.Register(
		OpenaiResponse,
		Claude,
		ConvertOpenAIResponsesRequestToClaude,
		interfaces.TranslateResponse{
			Stream:    ConvertClaudeResponseToOpenAIResponses,
			NonStream: ConvertClaudeResponseToOpenAIResponsesNonStream,
		},
	)
}
