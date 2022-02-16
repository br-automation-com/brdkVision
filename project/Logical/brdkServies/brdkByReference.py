# Import required python libraries
import os
import shutil

# ------------------------------------Import lxml corresponding to the Python version-----------------------------------
try:
    from lxml import etree
    #print("running with lxml.etree")
except ImportError:
    try:
        # Python 2.5
        import xml.etree.cElementTree as etree
        #print("running with cElementTree on Python 2.5+")
    except ImportError:
        try:
            # Python 2.5
            import xml.etree.ElementTree as etree
            #print("running with ElementTree on Python 2.5+")
        except ImportError:
            try:
                # normal cElementTree install
                import cElementTree as etree
                #print("running with cElementTree")
            except ImportError:
                try:
                    # normal ElementTree install
                    import elementtree.ElementTree as etree
                    #print("running with ElementTree")
                except ImportError:
                    print("Failed to import ElementTree from any known place")
                    exit()


# ---------------------------------------------Read trough all the packages---------------------------------------------
def read_package(path_from, path_to, sub_path, obj):  # Go trough all packages in project
    new_path_from = path_from + "\\" + sub_path # Combine the paths
    new_path_to = path_to + "\\" + sub_path # Combine the paths

    if os.path.exists(new_path_from + "\\Package.pkg"):  # Check for Package in new path
        print("\n" + obj.attrib["Type"] + ": " + obj.text)  # Print out folder name CAN BE DELETED
        tree = etree.parse(new_path_from + "\\Package.pkg").getroot()  # Make a tree of the new Package

        # Go trough the elements in the new package
        for sub_obj in tree.findall(".//{http://br-automation.co.at/AS/Package}Object"):
            if sub_obj.attrib["Type"] == 'File':  # If object is a file
                print("   "+sub_obj.attrib["Type"] + ": " + sub_obj.text)

            if sub_obj.attrib["Type"] == 'Package':  # If object is a Package
                create_object(new_path_from, new_path_to, sub_obj)  # Create the objects DOES NOT WORK!!!!!
                read_package(new_path_from, new_path_to, sub_obj.text, sub_obj)  # Make recursive call

    return


# ---------------------------------------------Delete all in folder---------------------------------------------
def delete_all(path_to):

    file_list = [f for f in os.listdir(path_to) if not f.endswith(".pkg")]
    for f in file_list:
        if os.path.isfile(os.path.join(path_to, f)):
            os.remove(os.path.join(path_to, f))

        if os.path.isdir(os.path.join(path_to, f)):
            shutil.rmtree(os.path.join(path_to, f))

    return


# ---------------------------------------Create the folders which does not exists---------------------------------------
def create_object(path_from, path_to, obj):
    if os.path.exists(path_to + "\\" + obj.text) == 0:
        copy_from = path_from + "\\" + obj.text
        copy_to = path_to + "\\" + obj.text

        os.makedirs(copy_to)
        shutil.copy(copy_from + "\\Package.pkg", copy_to + "\\Package.pkg")
        make_ref(copy_from, copy_to)

    return


# --------------------------------------------Make references in Package.pkg--------------------------------------------
def make_ref(copy_from, copy_to):
    tree = etree.parse(copy_to + "\\Package.pkg").getroot()

    for sub_obj in tree.findall(".//{http://br-automation.co.at/AS/Package}Object"):

        if sub_obj.attrib["Type"] == 'File':
            relative_from = copy_from.replace(os.path.dirname(os.path.abspath(os.path.join(__file__,'../../'))), "")
            ref = relative_from + "\\" + sub_obj.text
            sub_obj.text = ref
            sub_obj.set("Reference", "true")

    et = etree.ElementTree(tree)
    et.write(copy_to + "\\Package.pkg", pretty_print=True, xml_declaration=True, encoding="utf-8")

    return


# ----------------------------------------------------Modify Cpu.pkg----------------------------------------------------
def change_cpu(path_from, path_to):
    tree_from = etree.parse(path_from + "\\Cpu.pkg").getroot()
    tree_to = etree.parse(path_to + "\\Cpu.pkg").getroot()

    for obj in tree_to.findall(".//{http://br-automation.co.at/AS/Cpu}Object"):
        obj.getparent().remove(obj)

    for objs in tree_to.findall(".//{http://br-automation.co.at/AS/Cpu}Objects"):
        for obj in tree_from.findall(".//{http://br-automation.co.at/AS/Cpu}Object"):
            objs.append(obj)

    for obj in tree_to.findall(".//{http://br-automation.co.at/AS/Cpu}Object"):
        if obj.attrib["Type"] == 'File':
            relative_from = path_from.replace(os.path.dirname(os.path.abspath(os.path.join(__file__,'../../'))), "")
            ref = relative_from + "\\" + obj.text
            obj.text = ref
            obj.set("Reference", "true")

    et = etree.ElementTree(tree_to)
    et.write(path_to + "\\Cpu.pkg", pretty_print=True, xml_declaration=True, encoding="utf-8")

    return


# -----------------------------------------------------Choose path------------------------------------------------------

def choose_path(options, folder_path, configuration_folders):
    path = ""
    while os.path.exists(path) == 0:
        choose_folder = input("\tUse number: ")
        if choose_folder == "q":
            exit()
        try:
            val = int(choose_folder)
        except ValueError:
            val = 0

        if 0 < val <= options:
            path = os.path.normpath(os.path.join(folder_path, configuration_folders[val]))
            print("\tThe configuration is set to: ", configuration_folders[val])
        else:
            print("\tNot a valid input. Choose a valid option or quit program by 'q'\n")

    return path


# ----------------------------------------------------Look for path-----------------------------------------------------
def look_for_path(path_config):

    path = ""

    count_directories = 0
    for directories in os.listdir(path_config):
        if not "." in directories:
            path = os.path.normpath(os.path.join(path_config, directories))
            count_directories = count_directories + 1

    if count_directories > 1:
        y = 1
        configuration_folders = [None] * 10
        print("\n\tChoose a folder in this configuration:")
        for directories in os.listdir(path_config):
            if not "." in directories:
                print("\tPress:", y, "to choose the configuration:", directories)
                configuration_folders[y] = directories
                y = y + 1

        path = choose_path(count_directories, path_config, configuration_folders)

    return path

# ----------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------Main---------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------


CurrentFolder = os.path.dirname(os.path.abspath(__file__))
ASFolder = os.path.normpath(os.path.join(__file__,'../../../Physical/'))

print('This program has to be placed in the folder Logical/brdkScripts')
print('\tExampel: \tC:/BrAutomation/Projects/standardProject/Logical/brdkScripts')
print('The new configuration has to be created in Automation Studio\n')

if os.path.exists(ASFolder) == 0:
    Exit = input("\n\nThe script is not placed in the correct folder")
    exit()
print('Choose an old and a new configuration between the following: ')




configs = [None] * 10
x = 1
for directories in os.listdir(ASFolder):
    if not "." in directories:
        print("Press:", x, "to choose the configuration:", directories)
        configs[x] = directories
        x = x + 1

print("\nSource configuration: ")
pathFromConfig = choose_path(x, ASFolder, configs)
pathFrom = look_for_path(pathFromConfig)


print("\nDestination configuration: ")
pathToConfig = choose_path(x, ASFolder, configs)
pathTo = look_for_path(pathToConfig)

print("\n\nTrying to make a reference \n\tfrom: \t", pathFrom, "\n\tto: \t", pathTo)
print("\n\n------------------------------------------------------------------------------------")


# ----------------------------------------Program----------------------------------------

delete_all(pathTo)
if os.path.exists(pathFrom + "\\Cpu.pkg"):
    treeCpu = etree.parse(pathFrom + "\\Cpu.pkg").getroot()

    for objCpu in treeCpu.findall(".//{http://br-automation.co.at/AS/Cpu}Object"):
        print("------------------------------------------------------------------------------------")
        print("Looking in: " + pathFrom)
        if objCpu.attrib["Type"] == 'File':
            print(objCpu.attrib["Type"] + ": " + objCpu.text)

        if objCpu.attrib["Type"] == 'Package':
            subpathCpu = "\\" + objCpu.text
            create_object(pathFrom, pathTo, objCpu)
            read_package(pathFrom, pathTo, objCpu.text, objCpu)

        print("------------------------------------------------------------------------------------")

    change_cpu(pathFrom, pathTo)
else:
    print("No Cpu.pkg found")


Exit = input("\n\nThe reference configuration is done, enter an input to quit ")