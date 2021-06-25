#!/bin/bash
#
#
# Run with docker:
# $ bash geth_version.sh


# run container without network
# just to generate and manage keys
docker run \
	--mount type=bind,source=$(pwd),target=/smartenv \
	-it smartenv-geth:latest \
		geth \
		--nodiscover \
		--maxpeers 0 \
		--ipcdisable \
		--verbosity 6  \
		help 

