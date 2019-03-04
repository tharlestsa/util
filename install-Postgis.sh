
apt install -y wget

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RELEASE=$(lsb_release -cs)
echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}"-pgdg main | tee  /etc/apt/sources.list.d/pgdg.list

apt update

apt -y install postgresql-11

apt install postgresql-server-dev-11

# See the link: https://computingforgeeks.com/how-to-install-postgresql-11-on-debian-9-debian-8/

# http://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS24Debian9src

# grant all privileges on database money to cashier;

# host all all 0.0.0.0/0 md5

# alter user <username> with encrypted password '<password>';
# https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e
