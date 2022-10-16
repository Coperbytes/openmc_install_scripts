name = 'openmc_dagmc'
version = '0.13.1'

homepage = 'https://openmc.org/'
description = "OpenMC is a community-developed Monte Carlo neutron and photon transport simulation code."
docurls = ['https://docs.openmc.org/en/develop/']
software_license = 'MIT'
software_license_urls = ['https://docs.openmc.org/en/latest/license.html']
toolchain = {'name': 'GCC', 'version': '12.2.0'}

builddependencies = [('CMake', '3.18.4')]

dependencies = [
    ('Python', '3.8.2'),
    ('HDF5', '1.13.2'),
    ('SciPy-bundle', '2020.03', '-Python-%(pyver)s'),
    ('numpy', '1.23.0'),
    ('pandas', '1.5.0'),
    ('h5py', '3.7.0'),
    ('matplotlib', '3.6.0'),
    ('uncertanties', '3.1.7'),
    ('lxml', '4.9.1'),
]

easyblock = 'CMakeMake'

install_prefix = '/usr/local/lib'
configure_cmd = f"cmake -DOPENMC_USE_DAGMC=ON -DOPENMC_USE_OPENMP=ON -DOPENMC_USE_MPI=ON -DDAGMC_ROOT={install_prefix} -DHDF5_PREFER_PARALLEL=OFF -DCMAKE_INSTALL_PREFIX={install_prefix} .."
postinstallcmds = ['pip install ..']
