# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils user

DESCRIPTION="Syncplay allows people to enjoy a shared viewing experience even if they are thousands of miles apart."

HOMEPAGE="https://github.com/Syncplay/syncplay"
SRC_URI="https://github.com/Syncplay/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="vlc +X +client +server"

RDEPEND="
	X? ( >=dev-python/pyside-1.2.2[X,${PYTHON_USEDEP}] )
	>=dev-python/zope-interface-4.1.1
	>=dev-python/twisted-core-13.2.0[${PYTHON_USEDEP}]
"

DEPEND="
	vlc? ( media-video/vlc )
"

pkg_setup()
{
	enewgroup ${PN} || die "failed"
	enewuser ${PN} -1 -1 -1 ${PN} -1 || die "failed"
}

src_compile()
{
	return 
}

src_install() {
	if use vlc; then
		VLC="true"
	else
		VLC="false"
	fi

	use client && emake PREFIX="${D}" VLC_SUPPORT="$VLC" install-client || die "failed"
	use server && emake PREFIX="${D}" VLC_SUPPORT="$VLC" install-server || die "failed"

	doinitd ${FILESDIR}/init.d/*
	doconfd ${FILESDIR}/conf.d/*
}
