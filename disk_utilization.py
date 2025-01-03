import subprocess

#JUST FOR NOW I AM SETTING IT TO 5
threshold = 80

df_output = subprocess.check_output(["df", "-Th"]).decode("utf-8").splitlines()

ulist = []
dlist = []

for line in df_output[1:]:
    columns = line.split()
    print(columns)
    usage = columns[5].replace('%', '')
    mount_point = columns[6]
    
    ulist.append(int(usage))
    dlist.append(mount_point)

for i in range(len(ulist)):
    if ulist[i] > threshold:
        print(f"{dlist[i]} utilization is more than {threshold}%. Current Usage stands {ulist[i]}%!!")
