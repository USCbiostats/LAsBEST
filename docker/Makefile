gdrive:
	docker build -t uscbiostats/lasbest-gdrive:latest -f Dockerfile.gdrive .
rclone:
	docker run --rm -i -v$(pwd):/gdrive/ -e GD_TOKEN= -e GD_DRIVE_PATH= uscbiostats/lasbest-gdrive:latest ./rcloneish.sh copy  mydrive: /gdrive/gd
