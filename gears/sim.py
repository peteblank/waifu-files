import pybullet as p
import pybullet_data
import time

# Connect to PyBullet
p.connect(p.GUI)

# Set the search path to find OBJ and URDF files
p.setAdditionalSearchPath(pybullet_data.getDataPath())

# Load the plane (URDF) and gears (OBJ)
plane_id = p.loadURDF("robot.urdf")
gear1_id = p.loadURDF("FabConvert.com_gear_1.obj", [0, 0, 0.1])
gear2_id = p.loadURDF("FabConvert.com_gear_2.obj", [0.2, 0, 0.1])

# Set gravity
p.setGravity(0, 0, -9.8)

# Create a constraint to simulate the gear interaction
constraint_id = p.createConstraint(
    parentBodyUniqueId=gear1_id,
    parentLinkIndex=-1,
    childBodyUniqueId=gear2_id,
    childLinkIndex=-1,
    jointType=p.JOINT_GEAR,
    jointAxis=[0, 0, 1],
    parentFramePosition=[0, 0, 0],
    childFramePosition=[0, 0, 0]
)

# Set the gear ratio
p.changeConstraint(constraint_id, gearRatio=1.0)

# Run the simulation
for _ in range(10000):
    p.stepSimulation()
    time.sleep(1./240.)

# Disconnect from PyBullet
p.disconnect()
