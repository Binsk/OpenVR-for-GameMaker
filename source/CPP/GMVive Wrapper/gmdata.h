/**
    @author     Reuben Shea
    @date       05-28-17

    Details:
        Very simplistic structure that helps store GameMaker
        data.
 **/

#ifndef GMDATA_H
#define GMDATA_H
enum GmData_Type{gmdt_real, gmdt_string, gmdt_undefined};

class GmData
{
    public:
        GmData(){type = gmdt_undefined;};
        GmData(const char* string) {this -> string = string;
                                    type = gmdt_string;}
        GmData(double real) {this -> real = real;
                                    type = gmdt_real;}
        GmData_Type getType(){return type;};
        double getReal(){return real;};
        const char* getString(){return string;};

    private:
        double real = 0;
        const char* string = "";
        GmData_Type type;
};

class GmMatrix
{
    public:
        GmMatrix();
        GmMatrix(double* matrix);
        GmMatrix(vr::HmdMatrix34_t &matrix);
        GmMatrix(vr::HmdMatrix44_t &matrix);
        double* getMatrixAsArray();
        void setMatrix(vr::HmdMatrix34_t &matrix);
        void setMatrix(vr::HmdMatrix44_t &matrix);
        void writeToBuffer(double* buffer);
        GmMatrix operator=(vr::HmdMatrix34_t &matrix);
        GmMatrix operator=(vr::HmdMatrix44_t &matrix);
    private:
        std::vector<double> matrixData;
};

GmMatrix::GmMatrix()
{
    matrixData.resize(16, 0.);
}

GmMatrix::GmMatrix(double* matrix)
{
    matrixData.resize(16);
    for (uint32_t i = 0; i < 16; ++i)
        matrixData[i] = matrix[i];
}

GmMatrix::GmMatrix(vr::HmdMatrix34_t &matrix)
{
    setMatrix(matrix);
}

GmMatrix::GmMatrix(vr::HmdMatrix44_t &matrix)
{
    setMatrix(matrix);
}

double* GmMatrix::getMatrixAsArray()
{
    return matrixData.data();
}

void GmMatrix::setMatrix(vr::HmdMatrix34_t &matrix)
{
    matrixData.resize(16);
    matrixData[0] = matrix.m[0][0];
    matrixData[1] = matrix.m[1][0];
    matrixData[2] = matrix.m[2][0];
    matrixData[3] = 0.;

    matrixData[4] = matrix.m[0][1];
    matrixData[5] = matrix.m[1][1];
    matrixData[6] = matrix.m[2][1];
    matrixData[7] = 0.;

    matrixData[8] = matrix.m[0][2];
    matrixData[9] = matrix.m[1][2];
    matrixData[10] = matrix.m[2][2];
    matrixData[11] = 0.;

    matrixData[12] = matrix.m[0][3];
    matrixData[13] = matrix.m[1][3];
    matrixData[14] = matrix.m[2][3];
    matrixData[15] = 1.;
}

void GmMatrix::setMatrix(vr::HmdMatrix44_t &matrix)
{
    matrixData.resize(16);
    matrixData[0] = matrix.m[0][0];
    matrixData[1] = matrix.m[1][0];
    matrixData[2] = matrix.m[2][0];
    matrixData[3] = matrix.m[3][0];

    matrixData[4] = matrix.m[0][1];
    matrixData[5] = matrix.m[1][1];
    matrixData[6] = matrix.m[2][1];
    matrixData[7] = matrix.m[3][1];

    matrixData[8] = matrix.m[0][2];
    matrixData[9] = matrix.m[1][2];
    matrixData[10] = matrix.m[2][2];
    matrixData[11] = matrix.m[3][2];

    matrixData[12] = matrix.m[0][3];
    matrixData[13] = matrix.m[1][3];
    matrixData[14] = matrix.m[2][3];
    matrixData[15] = matrix.m[3][3];
}

GmMatrix GmMatrix::operator=(vr::HmdMatrix34_t &matrix)
{
    setMatrix(matrix);
    return *this;
}

GmMatrix GmMatrix::operator=(vr::HmdMatrix44_t &matrix)
{
    setMatrix(matrix);
    return *this;
}

void GmMatrix::writeToBuffer(double* buffer)
{
    for (uint32_t i = 0; i < 16; ++i)
        buffer[i] = matrixData[i];
}
#endif // GMDATA_H
