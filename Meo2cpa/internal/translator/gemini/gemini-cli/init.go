package geminiCLI

import (
	. "github.com/router-for-me/Meo2cpa/v6/internal/constant"
	"github.com/router-for-me/Meo2cpa/v6/internal/interfaces"
	"github.com/router-for-me/Meo2cpa/v6/internal/translator/translator"
)

func init() {
	translator.Register(
		GeminiCLI,
		Gemini,
		ConvertGeminiCLIRequestToGemini,
		interfaces.TranslateResponse{
			Stream:     ConvertGeminiResponseToGeminiCLI,
			NonStream:  ConvertGeminiResponseToGeminiCLINonStream,
			TokenCount: GeminiCLITokenCount,
		},
	)
}
