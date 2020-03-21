BuildFlavour = prof

ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

GhcStage2HcOpts += -eventlog

STRIP_CMD = :
