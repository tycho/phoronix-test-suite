#!/bin/sh

tar -xvjf JuliaGPU-v1.2pts-1.tar.bz2
cd JuliaGPU-v1.2pts/

patch -Np1 <<"EOF"
diff --git a/juliaGPU b/juliaGPU
index f404b5d..ea85b51 100755
Binary files a/juliaGPU and b/juliaGPU differ
diff --git a/juliaGPU.c b/juliaGPU.c
index cac9ea7..2eda5fd 100644
--- a/juliaGPU.c
+++ b/juliaGPU.c
@@ -143,6 +143,30 @@ static char *ReadSources(const char *fileName) {
 
 }
 
+static cl_platform_id pick_platform_for_type(cl_device_type type) {
+    cl_uint numPlatforms = 0;
+    cl_int st = clGetPlatformIDs(0, NULL, &numPlatforms);
+    if (st != CL_SUCCESS || numPlatforms == 0) return NULL;
+
+    cl_platform_id *plats = malloc(sizeof(*plats) * numPlatforms);
+    st = clGetPlatformIDs(numPlatforms, plats, NULL);
+    if (st != CL_SUCCESS) { free(plats); return NULL; }
+
+    cl_platform_id chosen = NULL;
+
+    for (cl_uint i = 0; i < numPlatforms; i++) {
+        cl_uint n = 0;
+        st = clGetDeviceIDs(plats[i], type, 0, NULL, &n);
+        if (st == CL_DEVICE_NOT_FOUND || n == 0) continue;   // this platform doesn't expose that type
+        if (st != CL_SUCCESS) continue;                      // some other issue, skip or handle
+        chosen = plats[i];
+        break;
+    }
+
+    free(plats);
+    return chosen;
+}
+
 static void SetUpOpenCL() {
 	cl_device_type dType;
 	if (useCPU) {
@@ -191,8 +215,8 @@ static void SetUpOpenCL() {
 			fprintf(stderr, "OpenCL Platform %d: %s\n", i, pbuf);
 		}
 
-		platform = platforms[0];
 		free(platforms);
+		platform = pick_platform_for_type(dType);
 	}
 
 	cl_context_properties cps[3] ={
EOF

case $OS_TYPE in
	"MacOSX")
		CCFLAGS="-O3 -march=native -ftree-vectorize -funroll-loops -Wall -framework OpenCL -framework OpenGL -framework GLUT"
	;;
	*)
		CCFLAGS="-O3 -march=native -ftree-vectorize -funroll-loops -Wall -lglut -lglut -lOpenCL -lGL"
	;;
esac

cc -o juliaGPU displayfunc.h camera.h vec.h renderconfig.h juliaGPU.c displayfunc.c $CCFLAGS -lm
echo $? > ~/install-exit-status
cpp <rendering_kernel.cl >preprocessed_rendering_kernel.cl
cd ~/

echo "#!/bin/sh
cd JuliaGPU-v1.2pts/
./juliaGPU \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > juliagpu
chmod +x juliagpu
