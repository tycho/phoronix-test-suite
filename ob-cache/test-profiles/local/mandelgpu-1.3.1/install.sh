#!/bin/sh

tar -xvjf MandelGPU-v1.3pts-1.tar.bz2
cd MandelGPU-v1.3pts/

patch -Np1 <<"EOF"
diff --git a/mandelGPU b/mandelGPU
index 3c8838c..2128e80 100755
Binary files a/mandelGPU and b/mandelGPU differ
diff --git a/mandelGPU.c b/mandelGPU.c
index 46cf376..494f112 100644
--- a/mandelGPU.c
+++ b/mandelGPU.c
@@ -124,6 +124,30 @@ static char *ReadSources(const char *fileName) {
 
 }
 
+cl_platform_id pick_platform_for_type(cl_device_type type) {
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
@@ -172,8 +196,8 @@ static void SetUpOpenCL() {
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
		CCFLAGS="-O3 -lm -ftree-vectorize -funroll-loops -Wall -framework OpenCL -framework OpenGL -framework GLUT"
	;;
	*)
		CCFLAGS="-O3 -lm -ftree-vectorize -funroll-loops -Wall -lglut -lglut -lOpenCL -lGL"
	;;
esac

gcc -o mandelGPU mandelGPU.c displayfunc.c $CCFLAGS
echo $? > ~/install-exit-status
cpp <rendering_kernel.cl >preprocessed_rendering_kernel.cl
cpp <rendering_kernel_float4.cl >preprocessed_rendering_kernel_float4.cl

cd ~/

echo "#!/bin/sh
cd MandelGPU-v1.3pts/
./mandelGPU \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > mandelgpu
chmod +x mandelgpu
