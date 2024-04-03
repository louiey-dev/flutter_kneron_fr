const int RID_REPLY =
    0x00; // Return status and data after processing the host’s KID command
const int RID_NOTE = 0x01; // Module reports the status or data to host
const int RID_IMAGE = 0x02; // Module sends image to host
const int RID_ERROR = 0x03;

// Indicates that the module is reset and the module is in the power-on default state after reset.
const int KID_RESET = 0x10;
const int KID_RESET_TIMEOUT = 1000;

// Get module status
const int KID_GET_STATUS = 0x11;
const int KID_GET_STATUS_TIMEOUT = 200;

// Starting face recognition
const int KID_VERIFY = 0x12;
const int KID_VERIFY_TIMEOUT = 10000;

// Starting new face registration
const int KID_ENROLL = 0x13;
const int KID_ENROLL_TIMEOUT = 10000;

// Forces unregistered faces to be enroll to any ID storage location
const int KID_ENROLLOVERWRITE = 0x14;
const int KID_ENROLLOVERWRITE_TIMEOUT = 10000;

// Capture images
const int KID_SNAP_IMAGE = 0x16;
const int KID_SNAP_IMAGE_TIMEOUT = 0;

// Captured images to DDR
const int KID_GET_SAVED_IMAGE = 0x17;
const int KID_GET_SAVED_IMAGE_TIMEOUT = 500;

// Return the image inside DDR to the host.
const int KID_UPLOAD_IMAGE = 0x18;
const int KID_UPLOAD_IMAGE_TIMEOUT = 10000;

// Single-frame Enroll
const int KID_ENROLL_SINGLE = 0x1D;
const int KID_ENROLL_SINGLE_TIMEOUT = 10000;

// Delete the specified registered face
const int KID_DEL_USER = 0x20;
const int KID_DEL_USER_TIMEOUT = 200;

// Delete all registered faces.
const int KID_DEL_ALL = 0x21;
const int KID_DEL_ALL_TIMEOUT = 200;

// Query specified face information
const int KID_GET_USER_INFO = 0x22;
const int KID_GET_USER_INFO_TIMEOUT = 200;

// Clear the enroll face direction
const int KID_FACE_RESET = 0x23;
const int KID_FACE_RESET_TIMEOUT = 200;

// Get all user information
const int KID_GET_ALL_USER_ID = 0x24;
const int KID_GET_ALL_USER_ID_TIMEOUT = 500;

// Integrated support and extension of all recording methods enroll methods
const int KID_ENROLL_ITG = 0x26;
const int KID_ENROLL_ITG_TIMEOUT = 10000;

// Getting version information.
const int KID_GET_VERSION = 0x30;
const int KID_GET_VERSION_TIMEOUT = 1000;

// Enter OTA upgrade mode
const int KID_START_OTA = 0x40;
const int KID_START_OTA_TIMEOUT = 0;

// Exit OTA mode, module reboot
const int KID_STOP_OTA = 0x41;
const int KID_STOP_OTA_TIMEOUT = 0;

// Get the OTA status and the starting packet number of the transmitted upgrade packet
const int KID_GET_OTA_STATUS = 0x42;
const int KID_GET_OTA_STATUS_TIMEOUT = 0;

// Size of upgrade packets sent, total number of packets, size of subpackets, md5 value of upgrade packets.
const int KID_OTA_HEADER = 0x43;
const int KID_OTA_HEADER_TIMEOUT = 0;

// Send upgrade packet : packet serial number, packet size, packet data.
const int KID_OTA_PACKET = 0x44;
const int KID_OTA_PACKET_TIMEOUT = 0;

// Setting the encrypted random number
const int KID_INIT_ENCRYPTION = 0x50;
const int KID_INIT_ENCRYPTION_TIMEOUT = 1000;

// Setting the communication port baud rate in OTA mode
const int KID_CONFIG_BAUDRATE = 0x51;
const int KID_CONFIG_BAUDRATE_TIMEOUT = 100;

// Set mass production encryption secret key sequence, power down will save it.
const int KID_SET_RELEASE_ENC_KEY = 0x52;
const int _TIMEOUT = 0;

// Setting the debugging encryption key sequence Setting the debugging encryption key sequence, lost at power down
const int KID_SET_DEBUG_ENC_KEY = 0x53;
const int KID_SET_DEBUG_ENC_KEY_TIMEOUT = 0;

// Importing face feature data into the device
const int KID_IMP_FM_DATA = 0x75;
const int KID_IMP_FM_DATA_TIMEOUT = 0;

// Setting up big data import
const int KID_SET_IMP_MASS_DATA_HEADER = 0x79;
const int KID_SET_IMP_MASS_DATA_HEADER_TIMEOUT = 0;

// Request to export the registration data of the corresponding user
const int KID_DB_EXPORT_REQUEST = 0x7C;
const int KID_DB_EXPORT_REQUEST_TIMEOUT = 0;

// Uploading data
const int KID_UPLOAD_DATA = 0x7D;
const int KID_UPLOAD_DATA_TIMEOUT = 0;

// Request to import the registration data of 1 user
const int KID_DB_IMPORT_REQUEST = 0x7E;
const int KID_DB_IMPORT_REQUEST_TIMEOUT = 0;

// Downloading data
const int KID_DOWNLOAD_DATA = 0x7F;
const int KID_DOWNLOAD_DATA_TIMEOUT = 10000;

// Host wakes up the face recognition module
const int KID_SOFT_RESET = 0xCA;
const int KID_SOFT_RESET_TIMEOUT = 0;

// Get device information
const int KID_KN_DEVICE_INF = 0xCB;
const int KID_KN_DEVICE_INF_TIMEOUT = 1000;

// Set algorithm security level
const int KID_SET_THRESHOLD_LEVEL = 0xD4;
const int KID_SET_THRESHOLD_LEVEL_TIMEOUT = 0;

// Module ends current task and prepares for shutdown
const int KID_POWERDOWN = 0xED;
const int KID_POWERDOWN_TIMEOUT = 1000;

// Set Demo mode
const int KID_DEMO_MODE = 0xFE;
const int KID_DEMO_MODE_TIMEOUT = 100;

// KID_ENROLL msg face direction
const int FACE_DIRECTION_UP = 0x10; // face up
const int FACE_DIRECTION_DOWN = 0x08; // face down
const int FACE_DIRECTION_LEFT = 0x04; // face left
const int FACE_DIRECTION_RIGHT = 0x02; // face right
const int FACE_DIRECTION_MIDDLE = 0x01; // face middle
const int FACE_DIRECTION_UNDEFINE = 0x00; // face undefine
